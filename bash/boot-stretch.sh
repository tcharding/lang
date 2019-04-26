#!/bin/bash
#
# Boot kernel using QEMU and stretch.img

KERNEL=/home/tobin/build/kernel/output/syzkaller/arch/x86/boot/bzImage
IMAGE=/home/tobin/build/imgs/stretch.img

sudo qemu-system-x86_64 -kernel $KERNEL -append "console=ttyS0 root=/dev/sda debug earlyprintk=serial slub_debug=QUZ" -hda $IMAGE -net user,hostfwd=tcp::10021-:22 -net nic -enable-kvm -nographic -m 2G -smp 2 -pidfile vm.pid  2>&1 | tee vm.log
