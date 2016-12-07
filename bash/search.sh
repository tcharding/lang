#!/bin/sh
#
# search.sh
#
# Wrapper for common case find command

WHERE= # where to start search
REGEX= # regular expresion to search for

if [ $# -eq 0 ]; then
    echo "Usage: $0 [directory] file"
    exit 0
fi

if [ $# -eq 2 ]; then
    WHERE="$1"
    REGEX="$2"
else
    REGEX="$1"
    # search base defined by $user
    if [ $USER = root ]; then
	WHERE='/'
    else
	WHERE='/home/tobin/'
    fi
fi

find $WHERE -name "$REGEX" -print

exit 0
