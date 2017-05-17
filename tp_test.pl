#! /usr/bin/perl

use strict;
use warnings;

use tp_step;
use tp_io;

sub test_parse {
    open(my $instructions,  "<",  shift)  or die "Can't open $!";
    
    while (<$instructions>) { # assigns each line in turn to $_
        tp_step::parse($_);
    }

    for my $key (keys %tp_io::variables) {
        print "$key => @{$tp_io::variables{$key}}\n";
    }

    print @tp_step::scripts;

    close $instructions or die "$instructions: $!";
}

sub test_step {
    tp_step::step();
}
    
test_parse($ARGV[0]);
test_step();
