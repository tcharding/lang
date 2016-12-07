#!/bin/bash
#
# start-day.sh - tasks run at start of each day
#
# Tobin Harding
SCRIPTS="${HOME}/cloud/plain-text/code/bash"

# mount external hard disk
su -c 'mount -t ext3 /dev/sdb1 /mnt/hd'

# clone / to external hard disk
if [ $? -eq 0 ]; then
su -c "${SCRIPTS}/clone.sh"
else 
    echo "Failed to mount external hard disk, not cloning /" >&2
    exit 1
fi

# tar up backups
"${SCRIPTS}/create-tarball-backups.sh"
if [ $? -gt 0 ]; then
    echo "Failed to tar up the back-ups" >&2
    exit 2
fi

# download email 
getmail --rcfile gmailrc --rcfile fastmailrc
if [ $? -gt 0 ]; then
    echo "Failed to download email" >&2
    exit 3
fi
