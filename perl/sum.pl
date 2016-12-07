#!/usr/bin/perl
use strict;
use warnings;
use feature qw/say/;

print "starting\n";
my @a = (1, 2, 3);
my $res = sum(@a);
print "res: $res\n";

sub sum {
    my @list = @_;
    my $sum;

    unless (@list) {
	$sum = 0;
    } else {
	for (@list) {
	    $sum += $_;
	}
    }

    return $sum;
}
