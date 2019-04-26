#!/bin/bash
#
# Set up window manager session how I like it.
#

terminal=/usr/sbin/terminator
sleep_period=1		  # Sleep for this many seconds to allow apps to launch.

set-desktop() {
    xdotool set_desktop $1
}

pause() {
    sleep $sleep_period
}

firefox-terminal() {
    /home/tobin/bin/setwindow.sh firefox 840 0 56 93
    terminator --geometry 839x1005+0+0
}

emacs-terminal() {
    /home/tobin/bin/setwindow.sh emacs 840 0 46 80
    terminator --geometry 839x1005+0+0
}

# WTF, emacs alwas starts on boot?
pkill emacs

# desktop 3: a terminal maximised
set-desktop 3
terminator -m
pause

# desktop 4: emacs and a terminal
set-desktop 4
emacs-terminal
pause

# desktop 5: firefo xand a terminal
set-desktop 5
firefox-terminal
pause

exit 0
