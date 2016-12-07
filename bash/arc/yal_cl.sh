#!/bin/bash
#
# ycc.sh: compile and link assembler file
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Command Paths
declare -rx rm="/usr/bin/rm" # the rm command

# File base name
declare FILE # file name argument
declare BASE # file name without extension
declare EXT # file name extension

# Sanity Checks
# -------------------
#
if test -z "$BASH" ; then
    printf "$SCRIPT:$LINENO: please run this script with the bash shell" >&2
    exit 192
fi
if test ! -x "$rm" ; then
    printf "$SCRIPT:$LINENO: the command $rm is not available - aborting\n" >&2
    exit 192
fi
    
# Main Script 
# -------------------

# Check usage
if [ $# -ne 1 ] ; then
    printf "%s\n" "Usage: yal_cl filename.asm"
    exit 192
fi

# Check filename format
FILE=$1 # get filename argument
EXT="${FILE##*.}" # get file extension

# check file extension
if [ "$EXT" != "asm" ] ; then
    printf "%s\n" "$SCRIPT error: file extension not 'asm'"
    printf "%s\n" "Usage: yal_cl filename.asm"
    exit 192
fi

BASE="${FILE%.*}" # remove suffix

$rm $BASE.o $BASE # remove object file and executable

exit 0
