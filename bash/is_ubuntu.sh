#!/bin/bash
#
# Simple script to check if we are running on Ubuntu

is_ubuntu=0

cat /etc/*-release | grep -i ubuntu >/dev/null
if [ $? == 0 ]; then
    is_ubuntu=1
fi

if [ $is_ubuntu = 1 ]; then
    echo "This is Ubuntu"
else
    echo "This is some other distro apart from Ubuntu"
fi

exit 0
