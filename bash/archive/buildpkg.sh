#!/bin/bash
#
# buildpkg.sh: automate the build package process
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Global Declarations
# -------------------
declare -rx SCRIPT=${0##*/}  # script name

# Command Paths
declare -rx tar="/usr/bin/tar"
declare -rx basename="/usr/bin/basename"

# file name variables
declare FILE
declare PKG
declare EXT
declare SRC_URL # URL of source tar ball

# Sanity Checks
# -------------------
#
if [ -z "$BASH" ] ; then
    printf "$SCRIPT:$LINENO: please run this script with the bash shell" >&2
    exit 192
fi
if [ ! -x "$tar" ] ; then
    printf "$SCRIPT:$LINENO: the command $tar is not available - aborting\n" >&2
    exit 192
fi
if [ ! -x "$basename" ] ; then
    printf "$SCRIPT:$LINENO: the command $basename is not available - aborting\n" >&2
    exit 192
fi

# Main Script 
# -------------------

# Check usage
if [ $# -ne 1 ] ; then
    printf "%s\n" "Usage: buildpkg.sh pkg-name.tar.gz"
    exit 192
fi

# get filename, extension (.tar.gz) and package name
FILE=`basename $1`
PKG=`echo $FILE | sed 's/\.tar\.gz//g'`
EXT=`echo $FILE | awk -F. '{print "."$(NF-1)"."$NF}'`

# check file extension
if [[ $EXT  != *.tar.gz ]] ; then
    printf "%s\n" "$SCRIPT error: file extension not '.tar.gz'"
    printf "%s\n" "Usage: buildpkg.sh pkg-name.tar.gz"
    exit 192
fi

printf "%s\n" "Untaring $FILE"
tar -xzvf $FILE
if [ ! -d $PKG ] ; then
    printf "%s\n" "$SCRIPT: dir $PKG does not exist, try buildpkg.sh -d $PKG pkg-name.tar.gz"
    exit 192
fi

cd $PKG

dl=`sed -n "s/DOWNLOAD=//p" $PKG.info | sed "s/\"//g"`
wget $dl
printf "slackbuild ready to be run in %s\n" $PKG
exit 0

