#!/bin/bash
#
# fire-term.sh - start firefox and a terminal on the side
firefox &
konsole --nofork --geometry=650x1015-0+0 &
