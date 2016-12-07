#!/bin/bash
#
# backup.sh - wrapper script for backup scripts
#
# Tobin Harding

WHO=$(whoami)
if [ "$WHO" != 'root' ]; then
    echo "$0 must be run as root .. aborting"
    exit 1
fi

exit 0
