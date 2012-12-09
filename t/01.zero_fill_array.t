#!perl

use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::More tests => 3;
}

my $got;

my $test_array = [ 1, 2, 3, 4 ];

$got = Statistics::PhaseOnlyCorrelation::_zero_fill( $test_array, 7 );
is_deeply( $got, [ 1, 2, 3, 4, 0, 0, 0, 0 ], "Fill zero." );
is_deeply( $test_array, [ 1, 2, 3, 4 ], "Check nondestructive." );

$got = Statistics::PhaseOnlyCorrelation::_zero_fill( $test_array, 2 );
is_deeply( $got, [ 1, 2, 3, 4 ], "Do nothing." );

done_testing();
