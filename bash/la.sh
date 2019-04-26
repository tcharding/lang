#!/bin/bash
#
# la.sh: Run leaking addresses script and copy results to eros

set -x

if [ -f /tmp/la.out ]; then
    rm /tmp/la.out
fi

date=$(date +"%Y%m%d%H%M")
hostname=$(hostname)
filename="/tmp/la-$hostname-$date.out"
uname=$(uname -a)

cat << EOF > $filename
Kernel scan for leaking addresses.

Output generated using scripts/leaking_addresses.pl from the kernel tree.

Host: $uname 

EOF


~/bin/leaking_addresses.pl -o /tmp/la.out
cat /tmp/la.out >> $filename
scp $filename eros:/home/tobin/la-logs/

exit 0

