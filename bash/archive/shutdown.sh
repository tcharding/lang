#!/bin/bash
#
# shutdown.sh - shutdown script
#
# Tobin Harding
HALT='/sbin/halt'
BSH='/home/tobin/cloud/plain-text/code/bash'
BACKUP="${BSH}/backup.sh"
ENCRYPT="${BSH}/encrypt-secure.sh -e"

# encrypt secure directory
$ENCRYPT

# git commit
DATE=$(date)
cd '/home/tobin/cloud/plain-text'
git commit -a --quiet -m "tAce: Automated commit $DATE"

# query on backup
response=
echo -n "Do you want to run backup.sh [Y/n]?: "
read response
response=${response,,}    # tolower
if [[ ! $response =~ ^(no|n)$ ]]; then
    $BACKUP
fi

# shutdown
echo
echo "Press any key to shutdown (Ctl-C to abort)" 
read dummy
$HALT
exit
