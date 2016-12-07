#!/bin/bash
# 
# launch-clients.sh - launch client processes
if [ $# -lt 1 ]; then
    echo "usage: launch-clients.sh num"
    exit 1
fi
num="$1"
echo "running client $num times"

for ((i=0; i<$num; i++))
do
    echo "${i}-test run of client" | ./client
done

