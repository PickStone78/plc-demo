#! /usr/bin/perl

use strict;
use warnings; 
use Time::HiRes qw(usleep);
use Step;

while(1) {
    Step::step();
    usleep(500000);
}
