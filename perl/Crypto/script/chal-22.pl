#!/usr/bin/perl
use strict;
#use warnings;
use feature qw/say/;

#
# Crack an MT19937 seed using brute force
#

#use Crypto::MT19937 qw/:all/;
use Crypto::Prng;

my( $u, $d ) = (11, 0xFFFFFFFF);
my( $s, $b ) = (7, 0x9D2C5680);
my( $t, $c ) = (15, 0xEFC60000);
my $a = 0x9908B0DF;
my $l = 18;
my $f = 1812433253;

#my $seed = &gen_seed;  # long run time if large seed, we brute force from 0
my $seed = 632;
#print "seed: $seed\n";

my $prng = Crypto::Prng->new;

$prng->seed( $seed );
my $v = $prng->extract_number();

my $guessed_seed = &attack_mt19937( $v );

print "Set 2 Challenge 22: ";
if ($seed == $guessed_seed) {
    print "Completed!\n";
} else {
    print "Failed\n";
}

sub attack_mt19937 {
    my $pnr = shift;
    my $max = 2**32;
    
    for my $seed (0 .. $max) {
	my $val = mt19937_value( $seed );
	if ($val == $pnr) {
	    return $seed;
	}
    }
    return -1;
}

# simulate MT19937 first value of sequence
sub mt19937_value {
    my $y = shift;

    $y = $y ^ (($y >> $u));
    $y = $y ^ (($y << $s) & $b);
    $y = $y ^ (($y << $t) & $c);
    $y = $y ^ ($y >> $l);

    return int32( $y );
}


# Get the 32 least significant bits.
sub int32 {
    my $n = shift;
    return int(0xFFFFFFFF & $n)
}

sub gen_seed {
#    sleep(rand(5));
    my $date = `date --rfc-3339=ns`;
    chomp $date;
    my @s = split /\./, $date;
    @s = split /\+/, $s[1];

    return int32($s[0]);
}
