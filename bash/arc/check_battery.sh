#!/bin/bash
#
# low_battery.sh: Alert user when battery charge is bellow threshold
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Command Paths
declare -rx cat="/usr/bin/cat" # the cat command
declare -rx grep="/usr/bin/grep" # the grep command
declare -rx play="/usr/bin/play" # sound player command
declare -rx awk="/usr/bin/awk" # the awk command

# Settings
declare -ir LOW_THRESHOLD=10 # percentage battery life considered low
declare -r BAT="BAT0" # battery identifier used by kernel (acpi)
declare -r ICON="/usr/share/icons/oxygen/48x48/devices/battery.png" # display icon
declare -r SOUND="/usr/share/orage/sounds/Knock.wav" # sound alert file 

# Battery Values
declare -i CUR_CAP # current capacity
declare -i MAX_CAP # maximum battery capacity
declare -i LOW_CAP # low battery capacity
declare STATE # charging or discharging

# Functions
# -------------------
function alert_battery_low {
    printf "%s\n" "Low Battery!" >&2
    $play -q $SOUND
    notify-send -u critical -t 5000 -i "$ICON" "Battery power low." "Remaining $CUR_CAP mWh"
}

# Sanity Checks
# -------------------
#
if test -z "$BASH" ; then
    printf "$SCRIPT:$LINENO: please run this script with the bash shell" >&2
    exit 192
fi
if test ! -x "$cat" ; then
    printf "$SCRIPT:$LINENO: the command $cat is not available - aborting\n" >&2
    exit 192
fi
if test ! -x "$grep" ; then
    printf "$SCRIPT:$LINENO: the command $grep is not available - aborting\n" >&2
    exit 192
fi
if test ! -x "$play" ; then
    printf "$SCRIPT:$LINENO: the command $play is not available - aborting\n" >&2
    exit 192
fi
if test ! -x "$awk" ; then
    printf "$SCRIPT:$LINENO: the command $awk is not available - aborting\n" >&2
    exit 192
fi
if [ ! -e "/proc/acpi/battery/$BAT/state" ] ; then
    printf "$SCRIPT:$LINENO: the file /proc/acpi/battery/$BAT/state is not available - aborting\n" >&2    
    exit 192
fi
if [ ! -e "/proc/acpi/battery/$BAT/info" ] ; then
    printf "$SCRIPT:$LINENO: the file /proc/acpi/battery/$BAT/info is not available - aborting\n" >&2    
    exit 192
fi

# Main Script 
# -------------------

# Check battery is present
PRESENT=$($grep "present:" /proc/acpi/battery/$BAT/state | $awk '{print $2}')
if [ "$PRESENT" != "yes" ] ; then
    printf "$SCRIPT:$LINENO: the battery does not appear to be present" >&2
    exit 192
fi

# Get battery values
STATE=$($grep "charging state" /proc/acpi/battery/$BAT/state | $awk '{print $3}')
CUR_CAP=$($grep "remaining capacity" /proc/acpi/battery/$BAT/state | $awk '{print $3}')
MAX_CAP=$($cat /proc/acpi/battery/BAT0/info | $grep 'last full' | $awk '{print$4}')
LOW_CAP=$(($LOW_THRESHOLD*$MAX_CAP/100))

printf "DEBUG: cur: %d, max: %d, low: %d, state: %s\n" $CUR_CAP $MAX_CAP $LOW_CAP $STATE

# Check capacity and state
if [ "$CUR_CAP" -lt "$LOW_CAP" ] && [ "$STATE" = "discharging" ] ; then
    alert_battery_low
fi

exit 0

