use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::More tests => 2;
}

my $got;

$got = Statistics::PhaseOnlyCorrelation->_pad([1,2,3,4], 7);
is_deeply($got, [1,2,3,4,0,0,0,0]);

$got = Statistics::PhaseOnlyCorrelation->_pad([1,2,3,4], 2);
is_deeply($got, [1,2,3,4]);

done_testing();
