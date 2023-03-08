#!/bin/sh
set -e

load_modules() {
        modprobe cdc-acm
        modprobe usbserial
}

start(){
        echo "Starting Arista Protocol Bridge..."
        PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
        load_modules

        # Enable the carrier board processor.
        if [ ! -d "/sys/class/gpio/gpio130" ]; then
                echo 130 > /sys/class/gpio/export || true
        fi

        echo high > /sys/class/gpio/gpio130/direction
        echo 1 > /sys/class/gpio/gpio130/value
        sleep 1

        cd /home/arista
        python3 utilities/setup_carrier_board.py
        python3 utilities/enableDevicePower.py
        python3 utilities/displayIpAddress.py || true
        python3 -m practichem_device.device_manager

        echo "Arista Protocol Bridge is already running."
        if [[ ! -f "/etc/protocolbridge.conf" ]]; then
                cp /home/arista//protocolbridge/config-arista.json /etc/protocolbridge.conf
        fi
        python3 /home/arista/protocolbridge/protocolbridge.py --configFile /etc/protocolbridge.conf
        echo "Started Arista Protocol Bridge."
}

stop(){
        echo "Stopping Arista Protocol Bridge..."

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
esac
