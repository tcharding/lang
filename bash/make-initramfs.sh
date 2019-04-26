#!/bin/bash
#
# Make the initramfs

main() {
    local label=$1

    create_mkinitcpio_config_file $label

    mkinitcpio -p linux-$label
}

# mkinitcpio preset file for the 'linux' package
create_mkinitcpio_config_file() {
    local label=$1
    local file="linux-${label}.preset"
    local path="/etc/mkinitcpio.d/$file"

    cat <<EOF > $path
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-$label"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
default_image="/boot/initramfs-$label.img"
#default_options=""

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-$label-fallback.img"
fallback_options="-S autodetect"

EOF
}

#
# main
#
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <boot-label>"
    exit 1
fi
main $@
