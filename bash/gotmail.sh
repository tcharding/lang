#!/bin/bash
#
# gotmail - check if there is new mail

BOXES=('IN-inbox' 'IN-catchall' 'IN-my-threads' 'IN-S-linux-newbies' 'IN-S-linux-crypto' 'IN-S-osi' 'IN-S-linux-kernel-janitors' 'IN-S-linux-kernel' 'IN-S-guile-bugs' 'IN-S-guile-devel' 'IN-S-guile-user')

for box in "${BOXES[@]}"
do
    DIR="${MAIL}/${box}/new"
    cd $DIR
    cnt=$(ls -l | grep "^-" | wc -l)
    if (( cnt > 0 ));
    then
	echo "$box"
    fi
done
