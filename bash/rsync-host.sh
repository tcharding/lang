#!/bin/bash
#
# `rsync` a host to remote server.

host=$(hostname)

main() {
    # cache sudo password
    sudo ls > /dev/null

    # sync home directory.
    rsync -avzrxHAX --partial --delete --delete-during \
	--exclude '.config/Signal/logs/app.log' \
	--exclude '.local/share/baloo/' \
	--exclude '.local/share/baloo/index' \
	--exclude '.xsession-errors' \
	--exclude '.local/share/klipper/' \
	--exclude '.local/share/klipper/history2.lst' \
	--exclude '.saves/auto-saves/' \
        --exclude '/.cache' \
        --exclude '/.cargo' \
        --exclude '/.mozilla' \
        --exclude '/.openjfx/cache' \
        --exclude '/.rustup' \
        /home/tobin/ "dinlas:/mnt/xhd/rsync/${host}/home/tobin"

    # tar and sync /etc directory.
    sudo rm /tmp/etc.tar.gz
    sudo tar -czvf /tmp/etc.tar.gz /etc
    rsync -avz /tmp/etc.tar.gz "dinlas:/mnt/xhd/rsync/${host}/home/tobin"
}

#
# Main script
#

main $@
