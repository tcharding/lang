#!/usr/bin/perl
use strict;
use warnings;
use feature qw/say/;

#
# ECB cut-and-paste
#

use MIME::Base64 qw(encode_base64 decode_base64);
use Crypt::Rijndael;
use Crypto::Block qw/:all/;
use Crypto::Base qw/:all/;

#&test_parse_to_json;
#&test_profile_for;

print "Aim: modify ciphertext to give user admin role\n";

my $key = &pseudo_random_string( 16 );

my $email = 'my@email.com';
my $profile = &profile_for( $email );
#print "\nInput: $email Profile: $profile\n";
#my $c = &encrypt( $profile, $key );
my $c = &input_and_encrypt( $email );

$c = attack( $c );

my $p = &decrypt( $c, $key );
$profile = &strip_padding( $p );
print "encypted/decrypted (key: $key): ";
print "$profile\n";
my $parsed = &parse_to_json( $profile );
print "$parsed\n";

# attack ECB encoded string
sub attack {
    my( $norole, $admin );	# encrypted blocks

    				# build first 2 blocks
    my $input = 'me@13byte.com'; # 13 bytes
    my $c = &input_and_encrypt( $input );
    $norole = substr( unpack('H*', $c), 0, 64 );

				# build third block
    $input = 'me@10by.te'; # gives [email=me@tobi.cc&uid=10&] as the first block
    $input .= pad( "admin", 16); # gives [admin......] as the second block
    $c = &input_and_encrypt( $input );
    $admin = substr(unpack('H*', $c), 32, 32);

    $c = pack('H*', ($norole . $admin));
    return $c;
}

# simulate accepting user input and encrypting
sub input_and_encrypt {
    my $profile = &profile_for( shift );
    &encrypt( $profile, $key );
}

# parse encoded string to JSON
sub parse_to_json {
    my $s = shift;
    # form: 'foo=bar&baz=qux&zap=zazzle'

    my $json .= sprintf "%s", "{\n";
    for (split /&/, $s) {
	my( $k, $v ) = split /=/, $_;
	$json .= sprintf "\t%s:\t'%s',\n", $k, $v;
    }
    $json .= sprintf "%s", "}\n";
}

sub test_parse_to_json {
    print "testing parse_to_json\n";
    my $tc_1 = "foo=bar&baz=qux&zap=zazzle";
    my $tc_2 = 'email=foo@bar.com&uid=10&role=user';

    my $parsed;
    $parsed = &parse_to_json( $tc_1 );
    print "tc1: $parsed\n";
    $parsed = &parse_to_json( $tc_2 );
    print "tc2: $parsed\n";
}

# encode email address as profile
sub profile_for {
    my $email = shift;
    my $options = index $email, "&";
    if ($options != -1) {
    	$email = substr( $email, 0, $options );
    }

    my $encoded = "email=" . $email . "&uid=10&role=user";
    return ( $encoded );
}

sub test_profile_for {
    my $tc_1 = 'foo@bar.com';
    my $tc_2 = 'foo@bar.com&role=admin';

    printf "testing profile_for\n";
    printf "1 (%s) %s\n", $tc_1, &profile_for( $tc_1 );
    printf "2 (%s) %s\n", $tc_2, &profile_for( $tc_2 );
}

# AES ECB mode
sub encrypt {
    my( $p, $k ) = @_;

    my $in = pad( $p, 16 );
    my $cipher = Crypt::Rijndael->new( $k, Crypt::Rijndael::MODE_ECB() );
    return $cipher->encrypt( $in );
}

# AES ECB mode
sub decrypt {
    my( $c, $k ) = @_;
    
    my $cipher = Crypt::Rijndael->new( $k, Crypt::Rijndael::MODE_ECB() );
    return $cipher->decrypt( $c );
}


