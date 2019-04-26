#!/bin/sh 
#
# Find files that exist in 'pool' that do not exist in 'rubbish'
#

pool=/home/tobin/go/src/crowdcoded.com.au/staticanalysis/HKG_DisplayData
rubbish=/home/tobin/go/src/crowdcoded.com.au/staticanalysis/removed

tempfile_prefix="/tmp/sta"
pool_out="$tempfile_prefix.pool"
rubbish_out="$tempfile_prefix.rubbish"


find $pool -type f  > $pool_out
find $rubbish -type f  > $rubbish_out

cat $rubbish_out | sed 's_.*/__' | sort |  uniq -d | 
    while read fileName
    do
	grep "$fileName" $pool_out
    done

