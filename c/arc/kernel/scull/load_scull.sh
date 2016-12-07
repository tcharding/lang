#!/bin/bash
#
# scull_load.sh
#
# Load scull module using dynamic device major numbers
#
# by Tobin Harding
#
# Acknowledge: "Linux Device Drivers, Third edition, by
# Jonathon Corbet, Alessandro Rubini, and Greg Kroah-Hartman.
# Copyright 2005 O'Rielly Media, Inc., 0-596-00590-3."
#
# Dual BSD/GPL Licence
# -----------------------
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -----------------------
declare -r SCRIPT=${0##*/}  # script name

# Command Paths
declare -rx insmod="/sbin/insmod" # insert module 
declare -rx awk="/usr/bin/awk" # the awk command
declare -rx rm="/usr/bin/rm" # remove file
declare -rx mknod="/usr/bin/mknod" # create special file
declare -rx grep="/usr/bin/grep"
declare -rx chgrp="/usr/bin/chgrp"
declare -rx chmod="/usr/bin/chmod"


# Module Variablse
declare -r MODULE="scull" # module name
declare -r DEVICE="scull" # device name
declare -r MODE="644" # file mode
declare -i MAJOR # major device number

# Main script starts here
# -----------------------

# Sanity Checks
# -----------------------
if test -z "$BASH" ; then
    printf "$SCRIPT: please run this script with the bash shell" >&2
    exit 192
fi
if [[ $EUID -ne 0 ]]; then
   printf "$SCRIPT: This script must be run as root" >&2
   exit 192
fi
if test ! -x "$awk" ; then
    printf "$SCRIPT: the command $awk is not available - aborting\n" >&2
    exit 192
fi
if test ! -x "$insmod" ; then
    printf "$SCRIPT: the command $insmod is not available - aborting\n" >&2
    exit 192
fi
if [ ! -x "$rm" ] ; then
    printf "%s\n" "$SCRIPT: $LINENO: Can't find/execute $rm" >&2
    exit 192
fi
if [ ! -x "$mknod" ] ; then
    printf "%s\n" "$SCRIPT: $LINENO: Can't find/execute $mknod" >&2
    exit 192
fi
if [ ! -x "$grep" ] ; then
    printf "%s\n" "$SCRIPT: $LINENO: Can't find/execute $grep" >2
    exit 192
fi
if [ ! -x "$chgrp" ] ; then
    printf "%s\n" "$SCRIPT: $LINENO: Can't find/execute $chgrp" >2
    exit 192
fi
if [ ! -x "$chmod" ] ; then
    printf "%s\n" "$SCRIPT: $LINENO: Can't find/execute $chmod" >2
    exit 192
fi
# Invoke insmod with all the arguments we got and use a pathname
# as newer modutils don't look in . by default
$insmod ./$MODULE.ko $* || exit 192

# remove stale nodes
$rm -f /dev/${DEVICE}[0-3]

# Get major number
MAJOR=$($awk "\$2==\"$MODULE\" {print \$1}" /proc/devices)

# create nodes
$mknod /dev/${DEVICE}0 c $MAJOR 0
$mknod /dev/${DEVICE}1 c $MAJOR 1
$mknod /dev/${DEVICE}2 c $MAJOR 2
$mknod /dev/${DEVICE}3 c $MAJOR 3

# set appropriate permissions, and change the group.
GROUP="staff"
$grep -q '^staff:' /etc/group || GROUP="wheel"

$chgrp $GROUP /dev/${DEVICE}[0-3]
$chmod $MODE /dev/${DEVICE}[0-3]
