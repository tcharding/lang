#!/bin/bash
#
# test.sh - run tests 

declare -i RESULT

for file in tst-client
do
    printf "Running %s ... " "${file}" >&2
    ("./$file")
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
	echo "ok"
    else
	echo "Failed: $RESULT"
    fi
done

if [ $# -gt 0 ]; then
    ./tst-verbrose
fi


exit 0
