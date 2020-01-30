#!/bin/bash
#
# Diff output from new and original versions of slabinfo.

diff=diff-ex-num                # github.com/tcharding/diff-ex-num
slabinfo=/usr/local/bin/slabinfo
slabinfo_rs=~/build/kdev/linux/tools/vm/slabinfo-rs/target/debug/slabinfo
out_dir=/tmp

orig_out=$out_dir/slabinfo.original.out
new_out=$out_dir/slabinfo.new.out

sudo $slabinfo > $orig_out
sudo $slabinfo_rs > $new_out

$diff $orig_out $new_out

exit 0
