#!/bin/bash
#
# push to SPOT server

# Passwordless access to this host is configured on each machine.
SERVER_NAME="lcn"
SPOT_DIR="SPOT"

main()
{
    echo "main"
}

push_to_lcn()
{
    rsync -avz "$HOME/$SPOT_DIR" lcn:"$HOME" --delete --ignore-errors
}

pull_from_lcn()
{
    rsync -avz lcn:"$HOME/$SPOT_DIR" $HOME
}

#
# Main script
#

if [ $# -lt 2 ]; then
    script=$(basename $0)
    echo "Usage: $script COMMAND" 
    echo ""
    echo "COMMAND"
    echo "	push	push ~/SPOT/ to server"
    echo "	pull	pull ~/SPOT/ from server"
    echo ""
fi

main $@
