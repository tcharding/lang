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
declare -rxi DEBUG=1 # set to 0 to turn off debugging

# Command Paths
declare -rx yasm="/usr/bin/yasm" # the yasm command
declare -rx ld="/usr/bin/ld" # the ld command

# Options
declare -rx ARCH="x86" # architecture
declare -rx FORMAT="elf" # use elf for linux machines
declare -rx MACHINE="amd64" # this is the default but lets be explicit
#declare -rx YFLAGS="-w+orphan-labels"

declare -x DFLAGS=
# conditionally set debug flags
if [ "$DEBUG" == 1 ] ; then
    DFLAGS="-g dwarf2"
fi

# File name variables
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
if test ! -x "$yasm" ; then
    printf "$SCRIPT:$LINENO: the command $yasm is not available - aborting\n" >&2
    exit 192
fi
if test ! -x "$ld" ; then
    printf "$SCRIPT:$LINENO: the command $ld is not available - aborting\n" >&2
    exit 192
fi

# Main Script 
# -------------------

# Check usage
if [ $# -ne 1 ] ; then
    printf "%s\n" "Usage: yal [clean] filename.asm"
    exit 192
fi

FILE=$1 # get filename argument
EXT="${FILE##*.}" # get file extension

# check file extension
if [ "$EXT" != "asm" ] ; then
    printf "%s\n" "$SCRIPT error: file extension not 'asm'"
    printf "%s\n" "Usage: yal filename.asm"
    exit 192
fi

BASE="${FILE%.*}" # remove suffix

#$yasm $DFLAGS $YFLAGS -a $ARCH  -f $FORMAT -m $MACHINE $FILE # compile to object file
$yasm $DFLAGS -a $ARCH  -f $FORMAT -m $MACHINE $FILE # compile to object file
$ld -o $BASE $BASE.o # link object into executable

exit 0
