package LocalIO;

use strict;
use warnings;
use Redis;

my $redis = Redis->new;

sub read {
    return $redis->get(shift) // die "Can't get $!";
}

sub write {
    my ($key, $val) = @_;
    print "$key, $val\n";
    $redis->set($key => $val) or die "Can't set $!";
}

END {
    $redis->quit;
}

1;
