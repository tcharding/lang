#!/bin/bash
#
# QEMU kernel fun
qemu-system-x86_64 -append "root=/dev/sda single"
		  
		   


# qemu-system-x86_64 -kernel /boot/vmlinuz-linux \
# 		   -drive file=~/build/imgs/qemu-image.img,index=0,media=disk,format=raw \
# 		   -append "root=/dev/sda single"

