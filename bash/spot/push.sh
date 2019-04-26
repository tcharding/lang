#!/bin/bash
#
# push to SPOT server

config=$(dirname $0)/config.sh
source $config

#source 

# We backup daily so we can go ahead and use 'delete' here.
rsync -avz "$HOME/$SPOT_DIR" lcn:"$HOME" --delete --ignore-errors
