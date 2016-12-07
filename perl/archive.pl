#!/usr/bin/perl
use strict;
use warnings;
use feature qw/say/;
use File::Copy;

#
# Create Archive, optionally move archive to DIR
#
my $DIR = '/home/tobin/archive';

if (@ARGV == 0) {
    die "Usage: $0 [-l] file\n"
}
my $file;
my $mv = 0;			# flag
if (@ARGV == 1) {
    $file = $ARGV[0];
} else {
    if (substr($ARGV[0], 0, 1) eq "-") {
	shift
    }
    $file = $ARGV[0];
    $mv = 1;
}

my $date = `date`;
my($days, $month, $dayn, $time, $zone, $year) = split / /, $date;
chomp $year;
my $new = sprintf "%s-%s-%s-%s", $year, $month, $dayn, $file;
my $path = sprintf "%s/%s", $DIR, $new;

move($file, $path);
#print "$path\n";
#copy($file, $new);
#nunlink $file;
#if ($mv == 1) {
#n    copy($new, $path) or die "Copy failed: $!";
#    unlink $new;
#}

