package Step;
use strict;
use warnings;
use LocalIO;
sub step {
my $register1;
my $register0;
$register0 = 1 ? 0 : 1;
$register0 = $register0 && 0;
LocalIO::write("%O:0", $register0);
$register0 = LocalIO::read("%O:0");
$register1 = 1;
$register1 += 2;
$register1 -= 1;
$register0 = $register0 || $register1;
LocalIO::write("%O:2", $register0);
hello:$register0 = LocalIO::read("%O:0");
LocalIO::write("%O:1", $register0);
}
1;