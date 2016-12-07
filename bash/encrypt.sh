#!/bin/bash

function encrypt-dir () {
    find . -type d -print |(
	while read dir; do
	    cd $dir
	    encrypt-files
	    encrypt-dir
	done
    )
}

function encrypt-files () {
    find . -type f \( ! -iname "*.gpg" \) |(
#    find . -type f -print |(
	while read file; do
	    gpg -e $file
	    rm $file
	done
    )
}

encrypt-dir

exit 0
