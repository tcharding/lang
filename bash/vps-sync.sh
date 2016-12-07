#!/bin/bash
#
# vps-sync.sh
#
# sync files with server
# Tobin Harding
LOCAL='/home/tobin/cloud'
#SERVER='tobin@vps' 
SERVER='tobin@vps:/home/tobin'
#SERVER='/mnt/hd/' # for testing
SECURE='/home/tobin/cloud/encrypted.bz2.gpg'

# Main Script

# Check sucure directory is encrypted
if [ ! -e "$SECURE" ]; then
    echo "secure directory not encrypted. Try encrypt-secure.sh before sync"
    exit 1
fi

case "$1" in
    --push | -u | put | -put | --put )
	echo 'Pushing data to vps' ;
	rsync -avbzutO --delete "${LOCAL}" "${SERVER}" ;;

    --pull | -d | -get | get | --get) 
	echo 'Pulling data from vps' ; 
	rsync -avbzutO --exclude *~ "${SERVER}/cloud" "${HOME}" ;;

    *) 
	echo "Usage: $0 option " ;
	echo "(options: -u --push | -d --pull )" ; exit 1 ;;
esac

exit 0
