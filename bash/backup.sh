#!/bin/bash		
#
# increment.sh - create incremental backups
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Pull from don
rsync -avz don:/etc /backup/host/don/

exit 0
