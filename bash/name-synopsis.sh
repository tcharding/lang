#!/bin/bash
#
# name-synopsis.sh
#
# Output man page information including only the name and the synopsis.
# Also allow the section number to be supplied as final parameter
#
# name-synopsis.sh <command> [section_number]
#
# Tobin Harding
CMND="$1"
SECTION=

if [ $# -eq 2 ]; then
    SECTION="$2"
fi

#upper=${CMND^^}

man $SECTION $CMND | awk 'NR==1, /DDEESSCCRRIIPPTTIIOONN/' | head -n -2

exit 0
