#!/bin/bash
#
# mount filesystem used by qemu

IMG=~/build/imgs/ubuntu.cow
MNT=/mnt/bootstrap-fs

# unmount file system

sudo umount $MNT/dev
sudo umount $MNT/proc
sudo umount $MNT/sys

sudo umount $MNT
