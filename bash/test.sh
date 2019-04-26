#!/bin/bash
#
# Test script using the rust `stdlib.sh`
#

source '/home/tobin/bin/stdlib.sh'

main() {
    assert_cmds
    set_globals
    echo 'This script works!'
    ls
}

assert_cmds() {
    need_cmd lsa
}

set_globals() {
    # Environment sanity checks
    assert_nz "$HOME" "\$HOME is undefined"
    assert_nz "$0" "\$0 is undefined"

    script=${0##*/}             # script name
}

#
# Run main
#

main "$@"
