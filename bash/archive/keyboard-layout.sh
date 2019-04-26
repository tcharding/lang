#!/bin/bash
LO=$1                                   
MAPS='/home/tobin/.Xmodmap.d'

case "$LO" in                                                                   
	'q' | 'qw' | 'qwerty' ) xmodmap "${MAPS}/qwerty" ;;
        'dvp' | 'dvorak-programmer' ) xmodmap "${MAPS}/dvorak-programmer" ;;
        'dv' | 'dvorak' ) xmodmap "${MAPS}/dvorak" ;;
        'dv-k' ) xmodmap "${MAPS}/dvorak-kinesis" ;;
        * ) echo "Error: unknown argument $LO" >&2 ; exit 1 ;; 
esac

exit 0 
