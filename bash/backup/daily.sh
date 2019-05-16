#!/bin/bash
#
# Host daily backup script

# NOTE: Set this for each host!
host="eros"

script_dir="/home/tobin/build/github.com/tcharding/lang/bash/backup"
backups="/var/backups"
log_file="/var/log/backup"

# backup commands
backup_home="$script_dir/backup-home.sh"
backup_etc="$script_dir/backup-etc.sh"

main()
{
    do_cmd $backup_home "create backup of home/"
    do_cmd $backup_etc "create backup of etc/"
    do_cmd sync_to_server "sync to lcn"
}

log()
{
    echo $1 >> $log_file
}

do_cmd()
{
    local cmd=$1
    local desc=$2
    local msg=$(date)

    $cmd
    if [ $? == 0 ]; then
	msg="$msg: $desc"
    else
	msg="$msg FAIL: $desc"
    fi
    log "$msg"
}

sync_to_server()
{
    rsync -avz $backups lcn:"$backups/$host" --delete --ignore-errors
}

#
#
#
main $@

exit 0

