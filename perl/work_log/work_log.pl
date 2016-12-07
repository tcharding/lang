#!/usr/bin/perl -w
use strict;
use autodie;
#./work_log.pl end dev unp 'completed ch 6'
#
# manage log entries
#
my $file = "/home/tobin/build/github/work-logs/December.md";
my $editor = "/usr/bin/emacs -nw"; # emacs in terminal window
#my $editor = "/usr/bin/emacs --maximized";
my $end_marker = '***** END *****';
    
if (@ARGV == 0) {
    system "vimcat $file";
    exit;
}

my $cmd = $ARGV[0];
if ($cmd eq "show") {
    &show;
} elsif ($cmd eq "new") {
    &new;
} elsif ($cmd eq "start") {
    &start($ARGV[1]);
} elsif ($cmd eq "end") {
    shift;
    &end (@ARGV);
} elsif ($cmd eq "edit") {
    &edit;
} elsif ($cmd eq "-h" || $cmd eq "--help") {
    &usage;
}
exit;

sub end {
    my $tmp = "tmp.file";
    open IN, '<', $file;
    open OUT, '>', $tmp;
    select OUT;
    
    while (<IN>) {
	chomp;
	if (/\A\d{2}:\d{2}\Z/) {
	    print "$_ ";
	    print &time_now;
	    printf " %s", shift @_;
	    printf " %s", shift @_;
	    print " - @_\n";
	} else {
	    print;
	    print "\n";
	}
    }
    rename $tmp, $file;
    select STDOUT;
}

sub new {
    my $tmp = "tmp.file";
    open IN, '<', $file;
    open OUT, '>', $tmp;
    select OUT;
    
    while (<IN>) {
	if (/END/) {
	    print "\n";
	    my $today = `date '+%A %d/%m/%y'`;
	    print $today;
	    print "----------------\n";
	    print;
	} else {
	    print;
	}
    }
    rename $tmp, $file;
    select STDOUT;
}

sub start {
    my $time = shift;
    my $tmp = "tmp.file";
    open IN, '<', $file;
    open OUT, '>', $tmp;
    select OUT;
    
    while (<IN>) {
	if (/END/) {
	    if (defined $time) {
		print $time;
	    } else {
		print &time_now;		
	    }
	    print "\n";
	    print;
	} else {
	    print;
	}
    }
    rename $tmp, $file;
    select STDOUT;
}
sub usage {
    print "Usage: $0 command [OPTION]\n";
    printf "\n Commands: \n\t show - print log file\n";
    printf "\n\t edit - edit log file\n\n";
    printf "\n\t add [OPTION]";
}

sub show {
    open my $in_fh, '<', $file;
    while (<$in_fh>) {
	print;
    }
}

sub edit {
    exec "$editor $file";
    die "Failed to exec: $!";
}

sub time_now {
    my $ds = `date`;
    my @date = split / /,$ds;
    my $hms = $date[4];		# change this to 3 if uninitialized var error

    my ($h, $m, $s) = split /:/, $hms;

    my $now = $h;
    $now .= ":";
    $now .= "$m";
}
