#!/bin/bash
#
# Create backup achive of home for current host

DIR='/var/backups/home'

if [ ! -d $DIR ]; then
    echo "Error: backup directory does not exist: $DIR";
    exit 127;
fi

cd $DIR
file=$(date +%F)-$(hostname)-home.tar.bz2
tar cjvPf $file /home \
    --exclude $HOME/SPOT \
    --exclude $HOME/music \
    --exclude $HOME/downloads \
    --exclude $HOME/scratch \
    --exclude $HOME/Webcam \
    --exclude $HOME/perl5 \
    --exclude $HOME/Desktop \
    --exclude "lost+found" \
    --exclude /home/archive

chown root:backup $file
chmod 664 $file

# remove older backups
find $DIR -type f -name '*-home-tar.xz' -mtime +90 -delete

exit 0
