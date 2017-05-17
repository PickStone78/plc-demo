#! /usr/bin/perl

use strict;
use warnings; 
use Time::HiRes qw(usleep);

use tp_step;

our $loop_flag = 1;

open(my $instructions,  "<",  $ARGV[0])  or die "Can't open $!";

while (<$instructions>) { # assigns each line in turn to $_
    tp_step::parse($_);
}

close $instructions or die "$instructions: $!";

while($loop_flag == 1) {
    tp_step::step();
    usleep(500000);
}
