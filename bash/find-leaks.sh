#!/bin/bash
#
# Find leaking kernel addresses

regex64='ffff[a-zA-Z0-9]{12}'
regex32='ffff{4}'
mask64='ffffffffffffffff'
mask32='ffffffff'

dmesg | egrep $regex64 | egrep -v $mask64

cat /proc/crypto | egrep 
