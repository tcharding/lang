#!/usr/bin/perl -w
use strict;
use autodie;

#
# Parse and format log file
#

die "Usage: $0 log_file\n"
    if (@ARGV == 0);

open my $log_fh, '<', $ARGV[0];
my $line;
while ($line = <$log_fh>) {
    if ($line =~ /\ASunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday/) {
	print $line;
	my $line = <$log_fh>;
	print $line;
	# process day
	my $total;
	while (($line = <$log_fh>) =~ /\w+/) {
	    $_ = $line;
	    my ($start, $end, $cat, $topic, $decs) = /(\S+) (\S+) (\S+) (\S+) (.*)/;
#	    printf "s: %s e:%s c:%s t:%s d:%s\n", $start, $end, $cat, $topic, $decs;
	    add_time($total, duration($start, $end));

	    print "\n";
	}
	print $total;
    }
}
# add $t1 to $t2
sub add_time {
    my ($t1, $t2) = @_;
    
    if (length($t1) == 3) {

    }
    if (length($t2) == 3) {
	my $tmp = "0";
	$tmp .= $t2;
	$t2 = $tmp;
    }
    my $h1 = substr($t1, 0, 2);
    my $m1 = substr($t1, 2, 2);
    my $h2 = substr($t2, 0, 2);
    my $m2 = substr($t2, 2, 2);
    my $h = $h1 + $h2;
    
}
# subtract $t1 from $t2
sub sub_time {
    my ($t1, $t2) = @_;
}

sub duration {
    my ($start, $end) = @_;
    my $sh = substr($start, 0, 2);
    my $sm = substr($start, 2, 2);
    my $eh = substr($end, 0, 2);
    my $em = substr($end, 2, 2);
    printf "$sh $sm $eh $em: ";
    # TODO handle end time after 0000
    my $dh;
    if ($eh >= $sh) {
	$dh = $eh -$sh;
    } else {
	$dh = 24 - $sh + $eh;
    }
    my $dm;
    if ($em >= $sm) {
	$dm = $em - $sm;
    } else {
	$dm = 60 - $sm + $em;
    }

    $dh .= $dm;
    print "$dh\n";
    return $dh;
}

