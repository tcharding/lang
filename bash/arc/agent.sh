#!/bin/bash
#
# agent.sh - start ssh-agent and gpg-agent
#
# Tobin Harding

case $1 in
    s | ssh | -s | --ssh )
	eval $(ssh-agent) ;
	ssh-add ;;
    k | -k | kill | --kill )
	eval $(ssh-agent -k) ;;
    * )
	echo "Unknown option: $1, try [-s, -k]" ;
	exit 1 ;;
esac

exit 0
