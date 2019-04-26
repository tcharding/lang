#!/bin/bash
wmctrl -n 8

firefox &
terminator &
emacs &
sleep 1

wmctrl -r terminator -t 3
#wmctrl -r mate-terminal -t 1 
wmctrl -r emacs -t 4
wmctrl -r firefox -t 5

#focus on terminal
wmctrl -a terminator
exit 0
