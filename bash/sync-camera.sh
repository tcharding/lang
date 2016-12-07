#!/bin/bash
#
# sync-camera.sh - get camera images from phone
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
SCRIPT=${0##*/}  # script name
HOST=
SRC_DIR="/storage/emulated/legacy/DCIM/Camera"
DST_DIR="${HOME}/pics/camera"
HOST='10.0.0.53'
#export RSYNC_PASSWORD="plaintext"

# Functions
# -------------------
usage () {
    echo "$SCRIPT host"
}

# Sanity Checks
# -------------------

if [ ! -e "$DST_DIR" ]
then 
    echo "Destination directory %s does not appear to exist ... aborting\n" "$DST_DIR"
    exit 1
fi

# Main Script 
# -------------------

if [[ $# > 0 ]]
then
    HOST=$1
fi

# check host is up
ping -c 1 $HOST || { printf "Host %s does not respond to ping\n" $HOST >&2; exit; }
rsync -avz "root@${HOST}:${SRC_DIR}/" "$DST_DIR"
exit 0
