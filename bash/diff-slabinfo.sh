#!/bin/bash
#
# Diff output from command A and B.

diff=/home/tobin/build/github.com/tcharding/diff-ex-num/target/debug/diff-ex-num
out_dir=/tmp

cmd_a="/usr/local/bin/slabinfo"
cmd_b="/home/tobin/build/kdev/linux/tools/vm/slabinfo-rs/target/debug/slabinfo"
# cmd_b="/usr/local/bin/slabinfo"

a_out=$out_dir/slabinfo.original.out
b_out=$out_dir/slabinfo.new.out


diff() {
    flag=$1
        
    rm -rf $a_out
    rm -rf $b_out
    
    sudo $cmd_a $flag | sort > $a_out
    sudo $cmd_b $flag | sort > $b_out

    $diff $a_out $b_out
}

echo "Diff'ing output of:"
echo "    $cmd_a"
echo "    $cmd_b"
echo ""

diff  ""                          # Simple invocation, no flags.

echo "Repeating with the following options:"
# TODO: long options.
flags=( "-h" "-B" "-D" "-e" "-f" "-h" "-i" "-l" "-L" "-n" "-N=10" "-o" "-P" "-r" "-s" "-S" "-t" "-T" "-U" "-v" "-X" "-z" "-1")
#flags=( "-z" "-B" )
for flag in ${flags[@]}; do
    echo "    slabinfo $flag"
    diff $flag
done

exit 0

# For reference

-a|--aliases           Show aliases
-A|--activity          Most active slabs first
-B|--Bytes             Show size in bytes
-D|--display-active    Switch line format to activity
-e|--empty             Show empty slabs
-f|--first-alias       Show first alias
-h|--help              Show usage information
-i|--inverted          Inverted list
-l|--slabs             Show slabs
-L|--Loss              Sort by loss
-n|--numa              Show NUMA information
-N|--lines=K           Show the first K slabs
-o|--ops               Show kmem_cache_ops
-P|--partial		Sort by number of partial slabs
-r|--report            Detailed report on single slabs
-s|--shrink            Shrink slabs
-S|--Size              Sort by size
-t|--tracking          Show alloc/free information
-T|--Totals            Show summary information
-U|--Unreclaim         Show unreclaimable slabs only
-v|--validate          Validate slabs
-X|--Xtotals           Show extended summary information
-z|--zero              Include empty slabs
-1|--1ref              Single reference
