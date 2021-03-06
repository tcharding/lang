#!/bin/bash
#
# yal [-c] file[.asm]: compile and link assembler file
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
declare -rx rm="/usr/bin/rm" # the rm command
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
declare BASE # file base name

# Functions
# -------------------
#

function usage {
    printf "%s\n" "Usage: yal [-c] filename"
    exit 192
}

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

# yal file | yal file.asm
if [ $# -eq 1 ]; then
    # get filename and basename
    if [[ $1 =~ .*\.asm ]]; then
        FILE="$1"
        BASE="${FILE%.*}" # remove suffix
    else
        BASE=$1 # source code base filename and executable name
        FILE="$BASE".asm 
    fi

    if [ ! -f "$FILE" ]; then
        printf "$SCRIPT:$LINENO: file $FILE does not exist\n" >&2
        exit 192
    fi
    # compile and link
    $yasm $DFLAGS -a $ARCH  -f $FORMAT -m $MACHINE $FILE # compile to object file
    $ld -o $BASE $BASE.o # link object into executable
    exit 0
fi

# yal -c file
if [ $# -eq 2 ]; then
    if [ ! $1 == "-c" ]; then
        printf "$SCRIPT:$LINENO: option $1 not supported\n" >&2
        usage
        exit 192
    fi

    BASE="$2" # source code base filename and executable name
    OBJ="$BASE".o

    if [ -f "$BASE" ]; then
        $rm $BASE
    fi
    if [ -f "$OBJ" ]; then
        $rm $OBJ
    fi
    exit 0
fi

usage
exit 192
