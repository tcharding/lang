#!/bin/bash
# 
# getoptex.sh
#
# demo parsing shell args
shopt -s -o nounset
shopt -s -o noclobber
set -e

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Command Paths
declare -rx getopt='/usr/bin/getopt'
usage () {
    echo "$program [options] arg"
    echo "-h | --help for help"
}

program="$(basename "$0")"

TEMP="$(getopt -o hvf: --long help,verbose,file: -n "$program" -- "$@")"

if (( $? )) ; then 
    echo "getopt error ... Aborting" >&2
    exit 1
fi

eval set -- "$TEMP"

VERBOSE='false'
FILE=

while true; do
    case "$1" in
	-h | --help ) echo 'help' ; exit 0 ;;
	-v | --verbose ) VERBOSE='true'; shift ;;
	-f | --file ) FILE="$2"; shift 2 ;;
	-- ) shift; break ;;
	* ) break ;;
    esac
done

echo "VERBOSE=$VERBOSE"
if [ "$FILE" ] ; then 
    echo "FILE=$FILE"
fi
	    
