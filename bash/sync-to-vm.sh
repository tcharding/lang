#!/bin/bash
#
# Sync file to disk image used by Qemu.

mount_script=/home/tobin/bin/mount-qcow-img

if [ $# -lt 1 ];
then
    script=`basename "$0"`
    echo "Usage: $script <file>"
    exit 0
fi


file=$1
rootfs="/mnt/rootfs"
dst="$rootfs/opt"


# fail if Qemu is running so we don't corrupt the image filesystem.
ps -e | grep qemu
if [ $? -eq 0 ];
then
    echo "Qemu appears to be running, kill it first"
    exit 1
fi


sudo $mount_script
sleep 1
sudo /bin/cp $file $dst
sleep 1
sudo $mount_script -u

exit 0
