#!/bin/bash
#
# create-tarball-backup.sh - create backup tree
#
# Tobin Harding
CLONE='/mnt/hd/clone'
DST='mnt/hd/backup/tobin'

# backup snapshots
#
# snapshot-1-day-ago
# snapshot-2-days-ago
# snapshot-3-days-ago

# TODO
# snapshot-1-week-ago
# snapshot-1-month-ago
SUFFIX='snapshot.tar.gz'

# rotate 
#mv "2d-${SUFFIX}" "3d-${SUFFIX}"
#mv "1d-${SUFFIX}" "2d-${SUFFIX}"

# tar up clone
FILE=$(mktemp)
EXCL=.mozilla,.serverauth*,.thunderbird,Downloads,build
cat "{${EXCL}}" >> "${FILE}"
tar -cjvvf --exclude "${FILE}" "${DST}/1d-${SUFFIX}" "${CLONE}/"

exit 0
