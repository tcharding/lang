#!/bin/bash
#
# Sync files onto laptop

SRC_HOST=eros

cd /home/tobin

dirs=( mail build go docs bin .getmail .mutt .passwords log .zprezto .sh  )
for dir in ${dirs[@]};
do
    rsync -avz eros:/home/tobin/$dir .
done

files=( .bashrc .gitconfig .mailfilter .msmtprc .mailrc )
for file in ${files[@]}
do
    scp eros:/home/tobin/$file .
done

