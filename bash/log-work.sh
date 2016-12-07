#!/bin/bash
#
# log-work.sh - make log entry for work done
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
SCRIPT=${0##*/}  # script name
LOG=${HOME}/WORKLOG.md

# Functions
# -------------------
usage () {
    local cmnd="log-work"
    echo "Work session log script."
    echo   
    printf "Current log file: %s\n" $LOG
    echo
    echo "Usage:"
    printf "\t %s newday [-n]\n" $cmnd
    printf "\t %s show [-s]\n" $cmnd
    printf "\t %s [ add [-a] ] %s\n" $cmnd "start_time end_time message"
    exit 1
}

# Sanity Checks
# -------------------
if [ ! -f $LOG ]
then
    echo "$SCRIPT: Error: log file does not exist ... aborting" >&2
    exit 1
fi

# Main Script 
# -------------------
if [ $# -eq 0 ]
then
    usage
fi

if [[ "$1" == "newday" ]] || [[ $1 == "-n" ]] || [[ "$1" == 'new' ]]
then
    echo ""
    echo $(date +"%A %d/%m/%y") >> $LOG
    echo "---------------" >> $LOG
    exit 0
    
fi


if [[ "$1" == "edit" ]] || [[ $1 == "-e" ]]
then
    emacs -nw "$LOG"
fi

if [[ "$1" == "show" ]] || [[ "$1" == "-s" ]]
then
    ccat $LOG
    exit 0
fi

if [[ "$1" == "add" ]] || [[ $1 == "-a" ]]
then
    shift
fi

echo "$@" >> $LOG
exit 0

