#!/bin/bash
#
# backup-vps.sh 
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Config
SRC='tobin@vps:/' # must have trailing slash
DST='/mnt/hd/backup/vps'       # back up directory (no trailing slash)
EXCL="${DST}/rsync-exclude.txt"       # rsync exclude file	        
MAX=10			       # number of incremental backups to keep

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Functions
# -------------------

# rotate directories (incremental backups)
function rotate ()
{
    local CUR=			# current increment directory
    local UP=			# next increment directory

   # rotate the others
    local i=$((MAX - 2))	# keep copies 0 through MAX-1
    while [ "$i" -gt 0 ]; do
	CUR=$i
	UP=$((i+1))
	mv $CUR $UP
	i=$(($i - 1))
    done

    return 0
}
# copy clone 
function duplicate ()
{
    if [ -d 0 ]; then
	cp -al 0 1		# create hard link version '1' of '0'
    fi

    return 0
}

function clone ()
{    
    # rsyc /* --del doesn't delete because of wildcard on source dir
    if [ -f '0/Created'* ]; then
	rm "0/Created_"*
    fi

    START=$(date +%s)
    rsync -aAvx --del "$SRC"* '0' --exclude-from="$EXCL" 
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

if [ ! -d "$DST" ]; then
    printf "$SCRIPT: source directory $DST does not appear to exist - aborting\n" >&2
    exit 192
fi

# Main Script 
# -------------------

# check for backup directory
if [ ! -d "${DST}" ]; then
    echo "$DST is no available"
    exit 1
fi
cd "$DST"

# back it up
rotate
duplicate
clone

exit 0
