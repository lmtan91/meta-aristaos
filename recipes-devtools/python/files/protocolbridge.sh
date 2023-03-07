#!/bin/sh
set -e

TEMP_DIR="/tmp/arista"

PROTOCOLBRIDGE="python3 /python/protocolbridge/protocolbridge.py --configFile /etc/protocolbridge.conf"
PROTOCOLBRIDGE_PID="${TEMP_DIR}/protocolbridge.pid"

LOG="rotatelogs -c -f -p /arista/flush-old-logs.sh -L /arista/log/protocolbridge.log /arista/log/dated/protocolbridge-%Y%m%d.log 100k"
LOG_PID="${TEMP_DIR}/protocolbridge-log.pid"

START_WITH_PID="--start --background --quiet --make-pid --pidfile"
START_BASH="--startas /bin/bash"
STOP_PID="--stop --retry TERM/30/KILL/5 --oknodo --pidfile"

PIPE="${TEMP_DIR}/protocolbridge.fifo"
create_pipe(){
	if [ ! -e $PIPE ]
	then	mkfifo $PIPE
	fi
}

load_modules() {
        modprobe cdc-acm
        modprobe usbserial
}

start(){
	echo "Starting Arista Protocol Bridge..."
	PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
	load_modules
	mkdir -p ${TEMP_DIR}
	create_pipe

        # Enable the carrier board processor.
        if [ ! -d "/sys/class/gpio/gpio130" ]; then
			echo 130 > /sys/class/gpio/export || true
		fi

        echo high > /sys/class/gpio/gpio130/direction
        echo 1 > /sys/class/gpio/gpio130/value
        sleep 1

	cd /python
	python3 utilities/setup_carrier_board.py
	python3 utilities/enableDevicePower.py
	python3 utilities/displayIpAddress.py || true
	python3 -m practichem_device.device_manager > /arista/log/devices.log

	if [ -e $LOG_PID ]
	then	echo "Arista Protocol Bridge Logging is already running."
	else	start-stop-daemon $START_WITH_PID $LOG_PID $START_BASH -- -c "exec stdbuf -oL tail -n +1 -f $PIPE | $LOG"
	fi

	if [ -e $PROTOCOLBRIDGE_PID ]
	then	echo "Arista Protocol Bridge is already running."
	else	start-stop-daemon $START_WITH_PID $PROTOCOLBRIDGE_PID $START_BASH -- -c "exec $PROTOCOLBRIDGE > $PIPE 2>&1"
	fi

	echo "Started Arista Protocol Bridge."
}
stop(){
	echo "Stopping Arista Protocol Bridge..."

	if [ -e $PROTOCOLBRIDGE_PID ]
	then	start-stop-daemon $STOP_PID $PROTOCOLBRIDGE_PID
		rm $PROTOCOLBRIDGE_PID
	else	echo "Arista Protocol Bridge is not running."
	fi

	echo "Stopped Arista Protocol Bridge."
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		sleep 1
		start
		;;
	status)
		status "${PROTOCOLBRIDGE}" || true
		;;
	*)
		echo "Usage: /etc/init.d/protocolbridge {start|stop|restart|status}"
		exit 1
esac
