#!/bin/bash
#
# add-alias - add shell alias
#
# Tobin Harding

ALIAS= # new alias
CMND= # target command
FILE="$HOME/.sh/alias.sh"

if [ ! $# -eq 2 ]; then
    echo "Usage: $0 alias command"
    exit 1
fi

ALIAS="$1"
CMND="$2"

echo "alias ${ALIAS}='${CMND}'" >> "${FILE}"
exit 0
