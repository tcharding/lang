#!/bin/bash		
#
# increment.sh - create incremental backups
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Config
# -------------------
MAX=10			        # number of incremental backups to make
BACKUP_ROOT_DIR='/mnt/sda3/backup'	
LOG='CLONED_ON'

# Functions
# -------------------

# move hard links one directory down the line (incremental backup)
function increment ()
{
    local CUR=			# current directory
    local INC=			# directory to increment into current
    local LAST=$((MAX-1))	
    local EOL="inc-${LAST}"	# end of life directory
    local i=$LAST              	# keep copies 0 through MAX-1
    local n=

    cd "$BACKUP_DIR"
    rm -rf "$EOL"/*		# clear out eol backup

    # rotate 
    while [ $i -gt 1 ]; do
	CUR="inc-${i}"
	n=$((i-1))
	INC="inc-${n}"
	mv "$INC"/* "$CUR"
	i=$(($i-1))
    done

    return 0
}
# create hard link copy of clone
function duplicate ()
{
    local ORIG="${BACKUP_DIR}/inc-0"	
    local DUP="${BACKUP_DIR}/inc-1"	

    if [ -d "$DUP" ]; then
	cp -alv "$ORIG"/* "$DUP"	# create hard links
    fi

    return 0
}

# Sanity Checks
# -------------------


# Main Script 
# -------------------

HOST=
# check args
if [ $# -gt 0 ]; then
    HOST=$1
else
    echo "Usage: $(basename $0) HOST" >&2
    exit 1
fi

BACKUP_DIR="${BACKUP_ROOT_DIR}/${HOST}"
if [ ! -d "$BACKUP_DIR" ]; then
    printf "$SCRIPT: backup directory $BACKUP_DIR does not appear to exist - aborting\n" >&2
    exit 192
fi

#CLONE="${BACKUP_DIR}/${HOST}/inc-0"
#INCREMENTAL="${BACKUP_DIR}/${HOST}/inc-1"

# check for new clone

# diff "${BACKUP_DIR}/inc-0/${LOG}" "${BACKUP_DIR}/inc-1/${LOG}" > '/dev/null'
# if [ $? -eq 0 ]; then 		# no new clone
#     echo "Host: $HOST. No new clone has been made." >&2
#     exit 0
# fi

# move incremental backups along
increment			
if [ $? -ne 0 ]; then
    echo "Error incrementing ... aborting" >&2
    exit 1
fi
# create initial hard links
duplicate			
if [ $? -ne 0 ]; then
    echo "Error duplicating ... aborting" >&2
    exit 1
fi

# append log entry
DATE=$(date  +%d-%m-%Y_%H:%M)	# get date
echo "Duplicated and incremented on $DATE" >> "${BACKUP_DIR}/log"

exit 0
