#!/bin/bash
#
# Create backup achive of /etc for current host

#
# Copy this script to /usr/local/bin
# Add cron job to run script daily
# @daily /usr/local/bin/backup-etc.sh >/dev/null
#

DIR='/var/backups/etc'

if [ ! -d $DIR ]; then
    echo "Error: backup directory does not exist: $DIR";
    exit 127;
fi

cd $DIR
file=$(date +%F)-$(hostname)-etc.tar.bz2
tar cjvPf $file /etc/

# remove older backups
find /var/backups -type f -name '*-etc-tar.xz' -mtime +90 -delete

exit 0
