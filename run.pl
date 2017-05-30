#! /usr/bin/perl

use strict;
use warnings; 
use Time::HiRes qw(usleep);
use Parser;
use Redis;

my $redis = Redis->new;

sub plc_read {
    return $redis->get(shift) // die "Can't get $!";
}

sub plc_write {
    my ($key, $val) = @_;
    $redis->set($key => $val) or die "Can't set $!";
}

my $loop_flag = 1;
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

$redis->quit;
