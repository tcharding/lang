#!/bin/bash
#
# sync mail from desktop to laptop

DESKTOP=eros
LAPTOP=caerus

RSYNC='rsync -avz'

# Directories
MAIL="/home/tobin/Mail"
GETMAIL="/home/tobin/.getmail"

for dirs in $MAIL $GETMAIL; do
    $RSYNC $DESKTOP:$dirs $dirs
done

# Files
MAILFILTER="/home/tobin/.mailfilter"
for file in $MAILFILTER; do
    scp $DESKTOP:$file $file
done

exit 0
