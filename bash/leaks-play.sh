#!/usr/bin/env perl

while (<>) {
          chomp;
          my $regex = 'test';

          while (/($regex)/g) {
                    print "got: ", $1, "\n";
                }
      }

      
