#!/bin/bash		
#
# backup.sh - backup host to external hard disk
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Config
SRC='/'				# must have trailing slash
HOST=$(hostname)
DST="/mnt/hd/backup/$HOST" # no trailing slash

# for testing
#SRC='/home/tobin/scratch/src/'
#DST='/home/tobin/scratch/dst'

EXCL="${DST}/rsync-exclude.txt"	# rsync exclude file	        
MAX=10			        # number of incremental backups to keep

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Functions
# -------------------

# move hard links one directory down the line (incremental backup)
function rotate ()
{
    local CUR=			# current directory
    local INC=			# directory to increment into current
    local EOL=$((MAX-1))	# end of life directory

    rm -rfv "$EOL"/*		# clear out eol backup

    # rotate the others
    local i=$EOL              	# keep copies 0 through MAX-1
    while [ $i -gt 1 ]; do
	CUR=$i
	INC=$((i-1))
	mv -v "${INC}"/* "$CUR"
	i=$(($i - 1))
    done

    return 0
}
# create hard link copy of rsync clone
function duplicate ()
{
    local SYNC='0'		# dir to rsync onto
    local LINK='1'		# dir of hard links to SYNC

    if [ -d "$SYNC" ]; then
	cp -alv "$SYNC"/* "$LINK"	# create hard links
    fi

    return 0
}
# clone SRC to DST using rsync
function clone ()
{        
    # rsyc /* --del doesn't delete because of wildcard on source dir
    if [ -f '0/Created'* ]; then
	rm '0/Created_'*
    fi

    START=$(date +%s)
    rsync -aAvx --del "$SRC"* "$DST"/0 --exclude-from="$EXCL" 
    FINISH=$(date +%s)
    
    DATE=$(date  +%d-%m-%Y_%H:%M)
    touch "0/Created_${DATE}"

    echo -n "total time: $(( ($FINISH-$START) / 60 )) minutes,"
    echo " $(( ($FINISH-$START) % 60 )) seconds"

    return 0  
}

# Sanity Checks
# -------------------
#
if [ ! -d "$SRC" ]; then
    printf "$SCRIPT: source directory $SRC does not appear to exist - aborting\n" >&2
    exit 192
fi
if [ ! -d "$DST" ]; then
    printf "$SCRIPT: destination directory $DST does not appear to exist - aborting\n" >&2
    exit 192
fi

# Main Script 
# -------------------

cd "$DST"			# tested existance in sanity checks
rotate				# move incremental backups along
duplicate			# create initial hard links
clone				# rsync SRC directory to DST
# win
exit 0
