#!/bin/bash
#
# Back up script using Duplicity
# Tobin Harding

LOG='/var/log/duplicity.log'
SRC='/'
DST='file:///mnt/xhd/duplicity/'
EXCLUDES='--exclude /mnt --exclude /proc --exclude /tmp --exclude /sys'

log_msg(){
    echo $@ >> $LOG
}

# verify external hard disk is mounted
lsblk | grep sdb1 | grep xhd >> /dev/null
if (( $? != 0 ));
then
    echo "Error: external hard disk not mounted" >&2
    exit 1
fi

# do incremental backup
duplicity --log-file $LOG --full-if-older-than 1M $EXCLUDES $SRC $DST --no-encryption

exit 0
