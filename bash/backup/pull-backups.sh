#!/bin/bash
#
# Pull backup directories down to this host.

THIS_HOST='caerus'
HOSTS=( 'don' 'caerus' )
BACKUP_DIR='/var/backups/host'

main() {
    verify_dest_dirs
    pull_etc_backups

    #    rsync -avz $host:/var/backups/etc /var/backups/host/$host
}

verify_dest_dirs() {
    
    for host in ${HOSTS[@]}; do
	dst="$BACKUP_DIR/${host}/etc"
	
	if [ ! -d "$dst" ]; then
	    echo "$0: Error: directory does not exist: $dst"
	    exit 127
	fi
    done
}

pull_etc_backups() {
    local src_dir=/var/backups/etc
    
    for host in ${HOSTS[@]}; do
	local src="${host}:${src_dir}/"
	if [ "$THIS_HOST" == "$host" ]; then
	    src="$src_dir/"	# No hostname for this host.
	fi

	local dst="$BACKUP_DIR/${host}/etc"

	rsync -avz $src $dst
    done
}
    

#
# Main script
#

main $@
exit 0;
