#!/bin/bash
#
# Cat /proc/slabinfo and fix up the columns
#  We can't fix this upstream for fear of breaking userspace tools.

tmp_file=$(mktemp)

sudo cat /proc/slabinfo > $tmp_file
#cat $tmp_file

#awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' $tmp_file

awk '{for (i = 1; i <= NF; i++); print i, $i; exit }' $tmp_file

rm $tmp_file


# echo * | head -n1 | sed -e 's/\s.*$//'
# printf '%-10s %-10s\n' $one $four; printf '%-10s %-10s\n' $six $nine
