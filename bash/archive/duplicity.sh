#/bin/bash
#
# duplicity backup script
#

# /home/tobin
duplicity --exclude "/home/tobin/.thunderbird/" --exclude "/home/tobin/.mozilla" --exclude "/home/tobin/build/kernel/" --verbosity info /home/tobin/ file:///home/dup/home/tobin/

# /etc
duplicity --verbosity info /etc/ file:///home/dup/etc
