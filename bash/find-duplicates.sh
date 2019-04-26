#!/bin/sh 
#
# Find duplicate files
# source: https://stackoverflow.com/questions/16276595/how-to-find-duplicate-filenames-recursively-in-a-given-directory-bash#16278407

dirname=/home/tobin/go/src/crowdcoded.com.au/staticanalysis/HKG_DisplayData
tempfile="/tmp/sta.out"

find $dirname -type f  > $tempfile

cat $tempfile | sed 's_.*/__' | sort |  uniq -d | 
    while read fileName
    do
	grep "$fileName" $tempfile
    done

