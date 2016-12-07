#!/usr/bin/perl
use strict;
use warnings;
use feature qw/say/;
use MIME::Base64 qw(encode_base64 decode_base64);

#
# Convert hex to base64
#

my $input = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
my $expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t";

my $bin = pack( 'H*', $input);
my $base64 = encode_base64( $bin );
chomp $base64;

print "Set 1 Challenge 1: ";
if ($base64 eq $expected) {
    print "Completed!\n";
} else {
    print "Failed\n";
    print "expected: $expected\n";
    print "We got:   $base64\n";
}


