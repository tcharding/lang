#!/bin/bash
#
# Sync SPOT/ to/from server

main()
{
    local cmd=$1

    if [ $cmd == "push" ]; then
	push_to_lcn
    elif [ $cmd == "pull" ]; then
	pull_from_lcn
    else
	echo "Unknown command: $cmd"
	exit 1
    fi

    exit 0
}

usage()
{
    echo "Usage: $script COMMAND" 
    echo ""
    echo "COMMANDS"
    echo ""
    echo "	push	sync ~/SPOT/ from host to server"
    echo ""
    echo "	pull	sync ~/SPOT/ from server to host"
    echo ""
    echo "WARNING: 'push' deletes files on the server if"
    echo "          they are not peresent on the host."
    echo ""
}

push_to_lcn()
{
    rsync -avz "$HOME/SPOT" lcn:"$HOME" --delete --ignore-errors
}

pull_from_lcn()
{
    rsync -avz lcn:"$HOME/SPOT" $HOME
}

#
# Main script
#

if [ $# -lt 1 ]; then
    script=$(basename $0)
    usage
    exit 0
fi

main $@
