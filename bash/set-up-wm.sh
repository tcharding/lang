#!/bin/bash
#
# Set up window manager session how I like it.
#

terminal=/usr/sbin/terminator
sleep_period=1		  # Sleep for this many seconds to allow apps to launch.
set_window="/home/tobin/build/github.com/tcharding/lang/bash/setwindow.sh"

set-desktop() {
    xdotool set_desktop $1
}

pause() {
    sleep $sleep_period
}

firefox() {
    $set_window firefox 840 0 56 93
}

emacs-terminal() {
    emacs --maximized
    terminator --maximize
#    $set_window emacs 840 0 46 80
#    terminator --geometry 839x1005+0+0
}

# desktop 1: a terminal maximised
set-desktop 1
terminator -m &
pause

# desktop 2: emacs and a terminal
set-desktop 2
emacs --maximized &
terminator --maximize &
pause

# desktop 3: firefox
set-desktop 3
firefox &
pause

exit 0
