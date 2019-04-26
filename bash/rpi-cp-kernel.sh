#!/bin/sh
#
# Copy Raspberry Pi kernel build to SDIO card
#
# Must be run as root
#

cp='/bin/cp'

# SD USB card reader auto mounts here
boot='/media/tobin/boot'

$cp arch/arm/boot/zImage $boot/kernel.img
$cp arch/arm/boot/dts/*.dtb $boot
$cp arch/arm/boot/dts/overlays/*.dtb* "$boot/overlays"
$cp arch/arm/boot/dts/overlays/README "$boot/overlays"
