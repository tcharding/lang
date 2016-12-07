#/bin/bash
#
# mount_ext.sh - conditionally mount external hard disk
#
# Tobin Harding

DEV='/dev/sdb1'		       # backup device
MNT='/mnt/hd'		       # back up mount location

eval "mount -l | grep $DEV > /dev/null"
if (( $? == 1 )); then
    echo mounting ...
    mount "$MNT"
else
    echo "already mounted"
fi

exit 0
