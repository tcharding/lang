#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX;

#
# Parse and format worklogs
#
my %days_ct;
my %days_tc;

my %catagories;
my %topics;

my $total_time;
my %times_by_day;
my %times_by_cat;
my %times_by_top;

my $file = $ARGV[0];
open STDIN, $file;
my $month = $file;
$month =~ s/\.md//g;

while (<STDIN>) {
    chomp $_;
    next unless / \d\d\/\d\d\/\d\d\Z/;
    my $day = $_;
    <STDIN>;				# skip underscore
    # parse day
    while (<STDIN>) {
	last if /\A\Z/;
	last if /END/;
	my ($start, $end, $cat, $top) = split;
	my $time = &duration($start, $end);
	$days_ct{$day}{$cat}{$top} += $time;
	$days_tc{$day}{$top}{$cat} += $time;
	$catagories{$cat}{$top} += $time;
	$topics{$top}{$cat} += $time;
	
	$times_by_day{$day} += $time;
	$times_by_cat{$cat} += $time;
	$times_by_top{$top} += $time;
	$total_time += $time;
#	print "Adding session: $day $cat $top $time\n";
    }
}

&print_totals;

# # Build time hashes
# for my $day (keys %days) {
#     for my $cat (keys %{ $days{$day} }) {
# 	for my $top (keys %{ $days{$day}{$cat} }) {
# 	    my $t = $days{$day}{$cat}{$top};
# 	    $times_by_day{$day} += $t;
# 	    $times_by_cat{$cat} += $t;
# 	    $times_by_top{$top} += $t;
# 	    $total_time += $t;
# 	}
#     }
# }
#print "days: ";
#print Dumper(\%days);
#print "catagorgies: ";
# print Dumper(\%catagories);
# print "topics ";
# print Dumper(\%topics);

sub print_totals {
    printf "%s: ", $month;
    &dump_time($total_time);
    print "\n";
    for my $cat (keys %catagories) {
	printf "\t%s: ", $cat;
	&dump_time($times_by_cat{$cat});
	print "\n";

	for my $topic (keys %{ $catagories{$cat} }) {
	    printf "\t\t%-10s ",$topic;
	    &dump_time( $catagories{$cat}{$topic});
	    print "\n";

	}
    }
}

# sub print_all_days {
#     print "$month: ";
#     &dump_time($total_time);
#     print "\n";
#     for my $day (keys %days) {
# 	print "$day: ";
# 	&dump_time($times_by_day{$day});
# 	print "\n";
# 	for my $cat (keys %{ $days{$day} }) {
# 	    print "\t$cat: ";
# 	    &dump_time($times_by_cat{$cat});
# 	    print "\n";
# 	    for my $top (keys %{ $days{$day}{$cat} }) {
# 		print "\t\t$top: ";
# 		&dump_time($times_by_top{$top});
# 		print "\n";
# 	    }
# 	}
#     }
# }


sub dump_time {
    my $time = shift;
    my $hours = $time / 60;
    my $minutes = $time % 60;
    printf "%sh %sm", floor($hours), $minutes;
}
sub compare {
    my ($a, $b) = @_;
    my ($aname, $adate) = split / /, $a;
    my ($aday, $amonth, $ayear) = split /\//, $adate;
    my ($bname, $bdate) = split / /, $b;
    my ($bday, $bmonth, $byear) = split /\//, $bdate;

    if ( $aday < $bday) {
	return 0;
    } else {
	return 1;
    }
}

# return duration in minutes
sub duration {
    my ($start, $end) = @_;
    my ($sh, $sm) = split /:/, $start;
    my ($eh, $em) = split /:/, $end;

    if ($eh < $sh) {
	$eh += 24;
    }
    my $hours = $eh - $sh;
    if ($em < $sm) {
	$em += 60;
	$hours -= 1;
    }
    my $minutes = $em - $sm;

    return $hours * 60 + $minutes;
}
