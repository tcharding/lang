#!/bin/bash
#
# Output last commit as a patch and run it through checkpath


rm -rf /tmp/00*
git format-patch -o /tmp -1

scripts/checkpatch.pl --terse --strict /tmp/00*
