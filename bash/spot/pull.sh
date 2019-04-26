#!/bin/bash
#
# pull from SPOT server

config=$(dirname $0)/config.sh
source $config

rsync -avz lcn:"$HOME/$SPOT_DIR" $HOME
