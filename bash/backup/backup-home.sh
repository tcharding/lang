#!/bin/bash
#
# Create backup achive of home for current host

dir='/var/backups/home'
src="/home/tobin"

if [ ! -d $dir ]; then
    echo "Error: backup directory does not exist: $DIR";
    exit 127;
fi

cd $dir
file=$(date +%F)-$(hostname)-home.tar.bz2

tar --exclude="$src/SPOT" \
    --exclude="$src/log" \
    --exclude="$src/music" \
    --exclude="$src/mail" \
    --exclude="$src/downloads" \
    --exclude="$src/scratch" \
    --exclude="$src/perl5" \
    --exclude="$src/Webcam" \
    --exclude="$src/.cache" \
    --exclude="$src/.cpan" \
    --exclude="$src/.cargo" \
    --exclude="$src/.emacs.d/elpa" \
    --exclude="$src/.mozilla" \
    --exclude="$src/.zprezto/modules" \
    --exclude="$src/.zprezto/.git" \
    --exclude="/home/lost+found" \
    --exclude="/home/archive" \
    -cjvPf $file $src

chown root:backup $file
chmod 664 $file

# remove older backups
find $DIR -type f -name '*-home-tar.xz' -mtime +90 -delete

exit 0
