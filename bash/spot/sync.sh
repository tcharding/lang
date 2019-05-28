#!/bin/bash
#
# Sync SPOT/ to/from server

server=nephele

main()
{
    local _delete=false
    local _help=false
    local _cmd=""

    local _arg
    for _arg in "$@"; do
        case "${_arg%%=*}" in
	    -d | --delete )
		_delete=true
		;;

            -h | --help )
                _help=true
                ;;

	    push )
		_cmd="push"
		;;

	    pull )
		_cmd="pull"
		;;

            *)
                echo "Unknown argument '$_arg', displaying usage:"
                echo ${_arg%%=*}
                _help=true
                ;;

        esac

    done

    if [ "$_help" = true ]; then
        print_help
        exit 0
    fi

    do_sync $_cmd $_delete 
}

print_help() {
echo '
Usage: spot-push [OPTIONS] COMMAND

Commands:

	push	sync ~/SPOT/ from local host to server"
	pull	sync ~/SPOT/ from server to local host"
	
Options:

     --delete, -d	Delete files during rsync (default for "push")
     --help, -h         Display usage information
'
}

do_sync()
{
    local cmd=$1
    local delete=$2

    if [ $cmd == "push" ]; then
	push_to_server
	return 0
    fi
	
    if [ $cmd == "pull" ]; then
	if [ $delete == true ]; then
	    pull_from_server_delete
	else
	    pull_from_server
	fi
    fi
}

# Default to deleting files when pushing.
push_to_server()
{
    rsync -avz "$HOME/SPOT" $server:"$HOME" --delete --ignore-errors
    log_action "push"
}

# Default to NOT deleting files when pulling.
pull_from_server()
{
    rsync -avz $server:"$HOME/SPOT" $HOME
    log_action "pull"
}

pull_from_server_delete()
{
    rsync -avz $server:"$HOME/SPOT" $HOME --delete --ignore-errors
    log_action "pull delete"
}

log_action()
{
    local action=$1
    local host=$(hostname)
    local date=$(date)

    local log_msg="$date    $host    $action"

    echo "$log_msg" | ssh $server "cat >> /home/tobin/spot.log"
}

#
# Main script
#

if [ $# -lt 1 ]; then
    script=$(basename $0)
    print_help
    exit 0
fi

main $@
