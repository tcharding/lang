#!/bin/bash
#
# archive.sh - create backups
# 
# Tobin Harding 
#

# config
DEV='/dev/sdb1'		       # backup device
MNT='/mnt/hd'		       # back up mount location
CLONE='/mnt/hd/clone'	       # clone directory
ARC='/mnt/hd/archive'	       # archive directory
INC=10			       # number of incremental backups to keep
HOST=$(hostname)

ismounted="mount -l | grep $DEV > /dev/null" # predicate

# functions

# clone root directory
clone () 
{
    DST="${CLONE}/$HOST"
    START=$(date +%s)
    rsync -aAxv --del /*  "$DST" --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/tmp/*} 
    FINISH=$(date +%s)
    rm "${DST}/Backed"* 
    echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds" | tee ${DST}/"Backed up: $(date '+%A %d-%m-%Y %T')"
    return 0
}
# assert device exists
assert_device ()
{
    ls "$DEV" > /dev/null
    if (( $? > 0 )); then
	echo "Device: $DEV is not present, is it plugged in?" >&2
	exit 1
    fi
    return 0
}

# assert root user
assert_root ()
{
    if [[ $EUID -ne 0 ]]; then
	echo "You must be a root user" 2>&1
	exit 1
    fi
    return 0
}


# Main Script

#assert_root
#assert_device

# conditionally mount
eval $ismounted
if (( $? == 1 )); then		# not mounted
    echo "Error: $MNT is not mounted"
    exit 1
    # /sbin/mount "$MNT"
    # eval $ismounted
    # if (( $? == 1 )); then		
    # 	echo "Failed to mount device" >&2
    # 	exit 1
    # fi
fi

# clone the disk
clone

# create hardlink mirror of clone
# NOW=$(date '+%A-%d-%m-%Y-%T')
# INC_DIR="${CLONE}/${HOST}/${NOW}"
# mkdir "$INC_DIR"
# cp -al "${CLONE}/${HOST}" "$INC_DIR"

# unmount
# umount "$MNT"
# eval $ismounted
# if (( $? == 0 )); then		# not mounted
#     echo "failed to umount $MNT" >&2
#     exit 1
# fi

exit 0
