#!/bin/bash
#
# slack_build.sh
#
# Build slack package
#
# takes slack build file as input, downloads source, does checks and builds pkg
#
# Tobin Harding

DEBUG=on # turn off debugging  with  'DEBUG=' 

# command paths
wget='/usr/bin/wget'
tar='/usr/bin/tar'

# functions

usage() {
   echo "$PRG foo.tar.gz" >&2
}

# debug function
debug() {
    [ DEBUG ] && echo $1
}

# Main Script
#
PRG=$0 # program name
TARBALL= # slack build tar ball
BUILD= # base name of package being built

debug "Building slack package..." >&2

# check args
if (( $# != 1 )); then
    usage
    exit 1
fi

TARBALL=$1
BUILD=$( echo "$TARBALL" | awk -F. '{ print $1 }' )
debug "package base name: $BUILD"

# check format of slackbuild parameter
REGEX='[*\.tar\.gz$]'
if [[ ! "$TARBALL" =~ $REGEX ]]; then 
    # incorrect parameter
    echo "Parameter does not appear to be a tarball"
    usage
    exit 1
fi
debug "untaring..." && debug ""
if [ -d "$BUILD" ]; then
    rm -rf "$BUILD"
fi

tar -xzvf "$TARBALL" && debug "" # untar

cd "$BUILD"

# get source code URL
SOURCE_URL=$( grep 'DOWNLOAD=' "${BUILD}.info" | awk -F\" '{ print $2 }' ) 
debug "source URL: $SOURCE_URL"
$wget  $SOURCE_URL

# check md5sum
VERSION=$( grep 'VERSION=' "${BUILD}.info" | awk -F\" '{ print $2 }' ) 
SOURCE_TARBALL=$( basename ${SOURCE_URL} )
debug "source: $SOURCE_TARBALL"
MD5IN=$( grep 'MD5SUM=' "${BUILD}.info" | awk -F\" '{ print $2 }' ) 
MD5OUT=$( md5sum "${SOURCE_TARBALL}" | awk '{ print $1 }' )
debug "md5in: $MD5IN"
debug "md5out: $MD5OUT"

if [ "$MD5IN" != "$MD5OUT" ]; then
    echo "md5sum's do not match, source download error" >&2
    exit 1
fi

su -c "./${BUILD}.SlackBuild $SOURCE > out"
PKG=$( tail -2 out | grep 'Slackware' | awk '{ print $3 }' )
debug "pkg: $PKG"
su -c "installpkg $PKG"
cp $PKG /home/tobin/build/packages
debug "move package $PKG to /home/tobin/build/packages"

exit 0

