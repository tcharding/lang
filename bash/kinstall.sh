#!/bin/bash
#
# Tobin's kernel install script

#
# Run as root, assumes we are in the output directory.
#

#
# sudo kinstall 5.1.0-rc1
#

main() {
    local label=$1
    local kimg="arch/x86_64/boot/bzImage"

    assert_root

    # Install the kernel
    cp $kimg "/boot/vmlinuz-${label}"

    # Make initramfs
    make-initramfs $label

    # Update grub
    grub-mkconfig -o /boot/grub/grub.cfg
    
    return 0
}

assert_root() {
    local iam=$(whoami)

    if [ $iam != 'root' ]; then
	echo "$0: error: requires root"
	exit 1
    fi
}

#
# main
#
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <boot-label>"
    exit 1
fi

main $@
