#!/bin/bash
#
# build kernel

cwd=$(pwd)
version=$(basename $cwd)

make LOCALVERSION=-$version -j9 EXTRA-CFLAGS=-W >/dev/null
