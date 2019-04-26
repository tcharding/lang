#!/bin/bash
#
# sync from eros to laptop

# build
#rsync -auvhz eros:/home/tobin/build caerus:/home/tobin/

# docs
#rsync -auvhz eros:/home/tobin/docs /home/tobin/

# files
#rsync -auvhz eros:/home/tobin/TODO.md /home/tobin/

dir=/home/tobin/tdir
rsync -auvhz eros:$dir caerus:$dir
rsync -auvhz caerus:$dir eros:$dir

exit 0
