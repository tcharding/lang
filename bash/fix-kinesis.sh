#!/bin/sh -e
#
# Call this from /etc/rc.local

# fix Kinesis USB keyboard
echo -1 > /sys/module/usbcore/parameters/autosuspend
echo -1 > /sys/bus/usb/devices/3-2/power/autosuspend_delay_ms

exit 0
