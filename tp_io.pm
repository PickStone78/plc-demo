package tp_io;

use strict;
use warnings;
use Redis;

our %variables;
my $redis = Redis->new;

sub read_global {
    foreach my $key (keys %variables)
    {
        my $var = $tp_io::variables{$key};
        if($var->[0] == 0 || $var->[0] == 2) {
            $var->[1] = $redis->get($key);
        }
    }
}

sub write_global {
    foreach my $key (keys %variables)
    {
        my $var = $tp_io::variables{$key};
        if($var->[0] == 1 || $var->[0] == 3) {
            $redis->set($key => $var->[1]);
        }
    }
}

1;
