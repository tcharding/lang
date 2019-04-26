#!/bin/bash
#
# Bash script template.

#
# Standard utilities and script design shamlessly stolen from the Rust project.
#
# Copyright 2015 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#

set -u # Undefined variables are errors

main() {
    assert_cmds
    set_globals
    handle_command_line_args "$@"
    debug

    echo "cmd: $cmd"
}

print_help() {
echo "
Usage: $script [OPTIONS]

OPTIONS:

     --verbose		Run with erbose output.
     --help, -h		Display this help and exit.
"
}

set_globals() {
    # Environment sanity checks
    assert_nz "$HOME" "\$HOME is undefined"
    assert_nz "$0" "\$0 is undefined"

    cmd='<cmd>'
    flag_verbose=false
    script=`basename "$0"`
}

handle_command_line_args() {
    local _help=false
    local _arg

    for _arg in "$@"; do
        case "${_arg%%=*}" in

            -h | --help )
                _help=true
                ;;

            --verbose)
                # verbose is a global flag
                flag_verbose=true
                ;;

	    start)
		cmd='start'
		;;

            *)
                echo "Unknown argument '$_arg', displaying usage:"
                echo ${_arg%%=*}
                _help=true
                ;;

        esac

    done

    if [ "$_help" = true ]; then
        print_help
        exit 0
    fi

    if [ $flag_verbose = true ]; then
	echo "Running script with verbose output "
    fi

    echo "command: $1"

}

debug() {
    say "Here is some normal output"
    verbose_say "Here is some verbose output"
    say_err "Here is some error output"
}

# Standard utilities (shamlessly stolen from the Rust project)

say() {
    echo "$script: $1"
}

say_err() {
    say "$1" >&2
}

verbose_say() {
    if [ "$flag_verbose" = true ]; then
        say "$1"
    fi
}

err() {
    say "$1" >&2
    exit 1
}

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1
    then err "need '$1' (command not found)"
    fi
}

need_ok() {
    if [ $? != 0 ]; then err "$1"; fi
}

assert_nz() {
    if [ -z "$1" ]; then err "assert_nz $2"; fi
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    "$@"
    need_ok "command failed: $*"
}

# This is just for indicating that commands' results are being
# intentionally ignored. Usually, because it's being executed
# as part of error handling.
ignore() {
    run "$@"
}

# Runs a command and prints it to stderr if it fails.
run() {
    "$@"
    local _retval=$?
    if [ $_retval != 0 ]; then
        say_err "command failed: $*"
    fi
    return $_retval
}

# Prints the absolute path of a directory to stdout
abs_path() {
    local _path="$1"
    # Unset CDPATH because it causes havok: it makes the destination unpredictable
    # and triggers 'cd' to print the path to stdout. Route `cd`'s output to /dev/null
    # for good measure.
    (unset CDPATH && cd "$_path" > /dev/null && pwd)
}

assert_cmds() {
    need_cmd dirname
}


main "$@"

# vim: set noet ts=8 sts=4 sw=4:
