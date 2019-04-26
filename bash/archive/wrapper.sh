#!/bin/bash
#
# wrapper.sh - run backup.sh for host: eros
#
# Tobin Harding

DEV='/dev/sdb1'			# backup device
MNT='/mnt/hd'			# mount point
BACKUP='./backup.sh'		# backup script

ismounted="mount -l | grep $DEV > /dev/null" # set $? (0 if mounted, 1 if not)

# Main Script

#
# TODO - add support for options (long and short)
#
# --help
# --umount umount on completion (default)
# --no-umount don't unmunt on completion
# --skip-mount-check -s 
#

eval $ismounted
if [ $? -eq 0 ]; then		# device already mounted
#    echo 'device $DEV is already mounted, aborting. (--help for options)' >&2
    echo "Device $DEV is already mounted, aborting." >&2
    exit 1
fi

# mount the device
mount "$DEV"
eval $ismounted
if [ $? -eq 1 ]; then		# device not mounted
    echo "Failed to mount device: $DEV. Aborting." >&2
    exit 1
fi

# Run the backup script
echo 'Running backup script'
echo
$BACKUP
echo
echo 'Backup complete, unmounting backup disk'

# unmount device
umount "$DEV"
eval $ismounted
if [ $? -eq 0 ]; then		# device not mounted
    echo "Failed to unmount device at $MNT" >&2
    exit 1
fi

exit 0
