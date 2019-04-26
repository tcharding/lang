#!/bin/bash
#
# mount filesystem used by qemu

MNT=/mnt/tmp

# unmount file system

sudo umount $MNT/dev
sudo umount $MNT/proc
sudo umount $MNT/sys

sudo umount $MNT
