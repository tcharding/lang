#!/bin/bash
#
# ch2x.sh - set file execution permissions
#
# Tobin Harding
if [ $# -eq 0 ]; then
    echo "Usage: ch2x.sh file1 file2 ..." >&2
    exit 0
fi
for file in $*
do
    chmod +x $file
done
exit 0
