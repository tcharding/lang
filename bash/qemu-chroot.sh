#!/bin/bash
#
# enter chroot using kernel dev Qemu image

IMG=~/build/imgs/qemu-image.img
MNT=/mnt/bootstrap-fs

sudo mount $IMG $MNT

sudo mount --bind /dev $MNT/dev
#sudo mount --bind /dev/pts $MNT/dev/pts
sudo mount -t proc proc $MNT/proc
sudo mount -t sysfs sys $MNT/sys

sudo chroot $MNT
