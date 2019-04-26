#!/bin/bash		
#
# increment.sh - create incremental backups
#
# Tobin Harding
shopt -s -o nounset
shopt -s -o noclobber

# Pull daily backups from cps
rsync -avz root@cps.crowdcoded.com.au:/var/backups/etc/ /backups/hosts/cps/etc

exit 0
