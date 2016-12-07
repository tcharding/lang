#!/bin/bash
#
# scull_load.sh - load and remove scull module
#
# Tobin Harding

MODULE="scull"
DEVICE="scull"
MODE="644"

#------------
# functions
#------------
insert_scull() {   
    # invoke insmod with all arguments we got and use a pathname, 
    # as newer modutils don't look in . by default
    /sbin/insmod ./${MODULE}.ko $* || exit 1
    
    echo "scull_load.sh: inserted module" >&2

    # remove stale nodes
    rm -f /dev/${DEVICE}[0-3]

    # get major number
    MAJOR=$(awk "\$1==\"$MODULE\" {print \$2}" /proc/modules)

    mknod /dev/${DEVICE}0 c $MAJOR 0
    mknod /dev/${DEVICE}1 c $MAJOR 1
    mknod /dev/${DEVICE}2 c $MAJOR 2
    mknod /dev/${DEVICE}3 c $MAJOR 3

    # give appropriate group permissions, and chonge the group.
    # Not all distributions have "staff", some have "wheel" instead.
    GROUP="staff"
    grep -q '^staff:' /etc/group || GROUP="wheel"

    chgrp $GROUP /dev/${DEVICE}[0-3]
    chmod $MODE /dev/${DEVICE}[0-3]
}

remove_scull() {
    echo
    # remove module
    rmmod $MODULE || exit 1
    echo "scull_load.sh: removed module" >&2

    # remove nodes
    rm -f /dev/${DEVICE}[0-3]
}

#------------
# Main script
#------------
ARG="$1"
case $ARG in
    i | -i | insert | --insert) insert_scull
	;;
    r | -r | remove | --remove) remove_scull
	;;
    *) echo "no option found: inserting scull module";
	insert_scull
	;;
esac

exit 0
