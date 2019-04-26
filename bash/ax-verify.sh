#!/bin/bash
#
# Displays whether the ax daemon is running or not
# and which driver is in use.

SCRIPT=`basename "$0"`

# commands
LSMOD=/sbin/lsmod
GREP=/bin/egrep
PS=/bin/ps

for tool in $LSMOD $GREP $PS ; do
    if [ ! -x $tool ]; then
	echo "$tool not found"
	exit 1
    fi
done

module=1
if [ "$1" == '--no-mod' ]; then
    module=0
else
    if [ "$1" == '--help' ] || [ "$1" == '-h' ]; then
	 echo "Usage: $SCRIPT [--no-mod]"
    fi
fi

     
$PS -e | $GREP ax | $GREP -v "$SCRIPT" > /dev/null
if [ $? != 0 ]; then
    echo 'ax daemon is not running'
    exit 1
fi

echo -n 'ax daemon is running: '



$LSMOD | $GREP ax > /dev/null
loaded=$?
if [ $module -eq 1 ]; then
    if [ $loaded == 1 ]; then
	echo 'user driver'
    fi
else
    if [ $loaded == 0 ]; then
	echo 'kernel driver'
    fi
fi

exit 0
