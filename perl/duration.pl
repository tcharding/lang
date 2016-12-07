#!/usr/bin/perl
use strict;
use warnings;

#time format 23:20
#

# test
print &duration("10:30", "11:40"), "\n\n";
print &duration("10:30", "11:10"), "\n\n";
print &duration("23:30", "00:40"), "\n\n";
print &duration("23:30", "00:10"), "\n\n";

# return duration in minutes
sub duration {
    my ($start, $end) = @_;
    my ($sh, $sm) = split /:/, $start;
    my ($eh, $em) = split /:/, $end;
    print "$sh $sm $eh $em\n";
    my $hours = 0;
    my $minutes;

    if ($eh < $sh) {
	$eh += 24;
    }
    $hours = $eh - $sh;
    if ($em < $sm) {
	$em += 60;
	$hours -= 1;
    }
    $minutes = $em - $sm;

    print "hours: $hours\nminutes: $minutes\n";
    return $hours * 60 + $minutes;
}
