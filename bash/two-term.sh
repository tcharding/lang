#!/bin/bash
#
# two-term.sh - start two terminals, one bigger than the other
konsole --nofork --geometry=1150x1010+0+0 &
konsole --nofork --geometry=770x1010-0+0 &
