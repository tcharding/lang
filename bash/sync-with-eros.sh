#!/bin/bash
#
# sync from eros to laptop

# build
#rsync -auvhz eros:/home/tobin/build caerus:/home/tobin/

# docs
#rsync -auvhz eros:/home/tobin/docs /home/tobin/

# files
#rsync -auvhz eros:/home/tobin/TODO.md /home/tobin/

root=/home/tobin
dir=tdir
rsync -auvhz eros:${root}/$dir .
rsync -auvhz $dir eros:${root}

exit 0
