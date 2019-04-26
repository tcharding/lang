#!/bin/bash
#
# Check how many patches I have in the mainline

ktree=/home/tobin/build/kdev/linux

cd $ktree

echo 'Greping git index of the mainline for patches by Tobin C. Harding ...'
nr=$(git log --author="Tobin C. Harding" --pretty=oneline | wc -l)

# First patches were done before I started using 'Tobin C. Harding'
#
# Add 7 for patches done by 'tcharding'
# Add 5 for patches done by 'Tobin C Harding'
nr=$((nr + 12))

echo ""
echo "    patches: $nr"
echo ""
echo "And of those, how many were _not_ into staging/ or docs patches ..."

nr=$(git log --author="Tobin C. Harding" --pretty=oneline | grep -v 'staging:' | grep -v 'docs:' | grep -v 'Documentation:' | grep -v 'doc:' | wc -l)

nr=$((nr + 10))			# 2 of the 12 were into staging.
echo ""
echo "    patches: $nr (total excluding docs and staging patches)"
echo ""

exit 0
