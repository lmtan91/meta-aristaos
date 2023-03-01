#!/bin/bash
# First-time install for Arista instruments
export NEW_PRIMARY_PARTITION=$(echo n; echo p)
export FIRST_AVAILABLE_BLOCK=$(echo;)
export ALL_REMAINING_SPACE=$(echo;)
export WRITE_PARTITIONS=$(echo w);
export SVN_CHANGES="
# Parameters copied from SVN's settings
listen_addresses = '*'
checkpoint_timeout = 15min
seq_page_cost = 1.0
random_page_cost = 1.5
log_destination = 'stderr'
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%a.log'
log_truncate_on_rotation = on
log_rotation_age = 1d
log_rotation_size = 0
log_line_prefix = '< %m >'
#log_timezone = 'US/Central'
#timezone = 'US/Central'
"
export PGTUNE_CHANGES="
# pgtune 2014-04-18
constraint_exclusion = on # pgtune wizard 2014-04-18
checkpoint_completion_target = 0.9 # pgtune wizard 2014-04-18
default_statistics_target = 100 # pgtune wizard 2015-01-15
wal_buffers = 13MB # pgtune wizard 2015-01-15
checkpoint_segments = 32 # pgtune wizard 2015-01-15
shared_buffers = 416MB # pgtune wizard 2015-01-15
max_connections = 100 # pgtune wizard 2015-01-15
work_mem = 8MB # pgtune wizard 2015-01-15 
maintenance_work_mem = 64MB # pgtune wizard 2015-01-15 * modified from 104MB
effective_cache_size = 1024MB # pgtune wizard 2015-01-15 * modified from 1280MB
"

# Expand the rootfs to the partition
ROOT_PARTITION=$(findmnt / --output SOURCE --noheadings)
resize2fs $ROOT_PARTITION

# Add swap partition to fstab
ROOT_DEVICE=$(lsblk $ROOT_PARTITION --output PKNAME --noheadings)
SWAP_PARTITION=/dev/${ROOT_DEVICE}p2 # Build mmcblk0p2 or mmcblk1p2 from ROOT_DEVICE
mkswap $SWAP_PARTITION
swapon $SWAP_PARTITION
echo -e "/dev/mmcblk0p2\tnone\tswap\tdefaults\t0\t0" >> /etc/fstab # For standard operation, mmcblk0p2 will always be the swap device.

# Add JAVA to the system's path
export PATH=$PATH:/usr/java/bin
echo PATH=\$PATH:/usr/java/bin >> /etc/profile

# Install pip3 from the install directory
if [ -e /install/get-pip.py ]
then	python3 /install/get-pip.py
fi

# Format and partition the external drive if present.
if [ -b /dev/sda ]
then	umount /dev/sda*
	dd if=/dev/zero of=/dev/sda bs=512 count=1
	fdisk /dev/sda << EOF
${NEW_PRIMARY_PARTITION}
1
${FIRST_AVAILABLE_BLOCK}
${ALL_REMAINING_SPACE}
${WRITE_PARTITIONS}
EOF
	mke2fs -t ext4 -L "arista" /dev/sda1
fi

# Create the standard mount point
mkdir /arista
echo -e "/dev/sda1\t/arista\text4\tdefaults,noatime\t0\t2" >> /etc/fstab

# Mount and initialize the new partition
mount /dev/sda1
mkdir -p /arista/log/dated
ln -sTf /arista/log/ /var/log/arista
mkdir /arista/database
chown postgres:postgres /arista/database
mkdir -p /etc/arista/
mv /root-filesystem-version.txt /etc/arista/

# Setup and initialize the database
sed -i -e "s:^PGDATA=/var/lib/postgresql/data$:PGDATA=/arista/database:" /etc/init.d/postgresql-server
sed -i -e "s:^PGLOG=/var/lib/postgresql/pgstartup.log$:PGLOG=/arista/log/postgres-startup.log:" /etc/init.d/postgresql-server
sudo -u postgres initdb -D /arista/database
sed -i -e "s:^host    all             all             127.0.0.1/32            ident$:host    all             all             127.0.0.1/32            md5:" /arista/database/pg_hba.conf
echo "${SVN_CHANGES}${PGTUNE_CHANGES}" >> /arista/database/postgresql.conf

# Create the user, database, and schema.
service postgresql-server start
sudo -u postgres psql -c "CREATE USER minot WITH PASSWORD 'minot';"
sudo -u postgres psql -c "CREATE DATABASE minotdb WITH OWNER=minot;"
sudo -u postgres psql -d minotdb -c 'CREATE EXTENSION "uuid-ossp";'
export PGPASSWORD=minot
psql -h localhost -U minot -d minotdb -c 'CREATE SCHEMA minot'

# Download and install the latest webapp
cd /arista/
wget http://arista-builder/job/JAVA.1_Public-Release-build-and-package/lastSuccessfulBuild/artifact/arista-release-latest.tgz
tar -zxf arista-release-latest.tgz
rm arista-release-latest.tgz
cd arista-install/
./install.sh
cd /arista/log

# Clean up
sleep 3
while [ "$(ps | grep do-install | grep -v grep | wc -l)" -gt "0" ]
do      echo Waiting for install processes:
        ps | grep install-scripts | grep -v grep
        echo Additional scripts running through bash:
        ps | grep /bin/bash | grep -v grep
        echo
        sleep 10
done
echo No more processes found.
echo Additional scripts running through bash:
ps | grep /bin/bash | grep -v grep
sleep 5
echo Java process: $(ps | grep java)
rm -rf /arista/arista-install

# stop the webapp
service webapp stop

# register the instrument, webapp depends on files added by registration
IP=$(ifconfig eth0 | awk '/inet addr/{print substr($2,6)}')
POST_HEADER="Content-Type: application/json"
POST_CONTENT='{"host": "'
POST_CONTENT+="${IP}"
POST_CONTENT+='", "username": "root", "password": "arista", "shouldResetPassword": false}'
REGISTER_HOST="ops.practichem.com"
REGISTER_URL="http://${REGISTER_HOST}/api/v1/register-arista"
curl -X POST -H "${POST_HEADER}" -d "${POST_CONTENT}" $REGISTER_URL -v

# Update protocolbridge configuration with buffer selector identities
service protocolbridge stop
python3 /python/utilities/identify_buffer_selectors.py --filename /etc/protocolbridge.conf

# wait for registration to complete
while [ ! -e /etc/arista/product-id.txt ]
do	echo Waiting for registration to complete
	sleep 10
done

# Update the database with the basic (wiped) database
/var/www/webapp/shell-utils/db-wipe.sh

# Enable services
update-rc.d -f postgresql-server remove
update-rc.d postgresql-server defaults 50
update-rc.d protocolbridge defaults 80 20
update-rc.d webapp defaults 90 10

# Start services
service ntpd start
service protocolbridge start
service webapp start

# Create an SSL key for nginx
mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 7000 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -batch
service nginx restart

# indicate completion to the user
echo 0 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio0/direction
echo 1 > /sys/class/gpio/gpio0/value
