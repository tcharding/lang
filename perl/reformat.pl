#!/usr/bin/perl -w
use strict;

$^I = "";

while (<>) {
    s/(\d\d)(\d\d)/$1:$2/g;
    print $_;
}
