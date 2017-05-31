#! /usr/bin/perl

use strict;
use warnings; 
use Time::HiRes qw(usleep);
use Parser;
use LocalIO;

my $register;

Parser::parse_file($ARGV[0]);

open(my $step,  "<",  "step.pl") or die "Can't open $!";
my @scripts = <$step>;

while(1) {
    my $line;
    foreach $line (@scripts) {
        eval $line; die $@ if $@;
        usleep(500000);
    }
}

close $step or die "$step: $!";
