#!/bin/bash
#
# encrypt-secure.sh - encrypt/decrypt secure directories
#
# Tobin Harding
ME='tharding@lgnt.com.au'
ROOT='/home/tobin/cloud'
SECURE='encrypted'

# functions

usage () {
    echo "Usage: $0 option (-d | -e)"
}

# Encrypt directory
encrypt ( ) {
    cd "${ROOT}"
  
    if [ -e "${SECURE}.bz2.gpg" ]; then
	echo 'already encrypted...aborting'
	exit 0 		# directory already encrypted
    fi

    echo "Encrypting ${ROOT}/${SECURE}";

    tar -cJf "${SECURE}.bz2" "${SECURE}"

    if [ ! $? -eq 0 ]; then
	echo "$0: tar error, exiting without completeing sync" >&2
	exit $?
    fi   
    
    gpg -r "$ME" -e "${SECURE}.bz2"

    if [ ! $? -eq 0 ]; then
    	echo "$0: gpg error, exiting without completeing sync" >&2
    	exit $?
    fi

    # remove originals
    rm -r "${SECURE}" 
    rm "${SECURE}.bz2" 

    return 0
}

# Decrypt directory
decrypt () {
    cd "${ROOT}"

    if [ ! -e "${SECURE}.bz2.gpg" ]; then
	echo 'directory not encrypted...aborting'
	exit 0 		# directory already encrypted
    fi

    echo "Decrypting ${ROOT}/${SECURE}";
    
    # decrypt
    gpg "${SECURE}.bz2.gpg"
    # untar
    tar -xJvf "${SECURE}.bz2"
    # cleanup
    rm "${SECURE}.bz2" 
    rm "${SECURE}.bz2.gpg"
    return 0
}

# Main Script

if [ $# -eq 0 ]; then # encrypt by default
    encrypt
    exit 0
elif [ $# -eq 1 ]; then
    case "$1" in
	-h | --help) usage ;;
	-d ) decrypt ;;
	-e ) encrypt ;;
	*) usage
    esac
fi

exit 0
