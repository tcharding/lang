#!/bin/bash
#
# clear-boot-dir.sh -  Remove files from /boot

remove-files() {
    local label=$1
#    files=("config" "initrd.img" "vmlinuz" "System.map" "retpoline" "abi")
    files=("initramfs-$label.img" "initramfs-$label-fallback.img" "vmlinuz-$label")

    # loop over files, append label and delete
    for file in "${files[@]}"
    do
        rm -rf "/boot/$file"
    done
}

remove-modules() {
    local label=$1
    rm -rf /lib/modules/5.0.0-${label}*
}

if (( $# < 1 ))
then
    echo "Usage: $0 <label> ..."
    exit 1
fi

for label in "$@"
do
    remove-files $label
    remove-modules $label
done

grub-mkconfig -o /boot/grub/grub.cfg
