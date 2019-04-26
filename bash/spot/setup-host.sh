#!/bin/bash
#
# Set up host to use SPOT directory

set -u

add_symlink()
{
    local target=$1
    local link=$2

    ln -s /home/tobin/SPOT/$target /home/tobin/$link
}

add_symlink build build
add_symlink Documents docs
add_symlink Pictures pics

exit 0

