use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::Most tests => 4;
}

my $got;

my $test_array = [1];
$got = Statistics::PhaseOnlyCorrelation::_get_zero_array($#$test_array);
is_deeply( $got, [0] );

$test_array = [ 1, 2 ];
$got = Statistics::PhaseOnlyCorrelation::_get_zero_array($#$test_array);
is_deeply( $got, [ 0, 0 ] );

$test_array = [ 1, 2, 3 ];
$got = Statistics::PhaseOnlyCorrelation::_get_zero_array($#$test_array);
is_deeply( $got, [ 0, 0, 0 ] );

$test_array = [];
dies_ok { Statistics::PhaseOnlyCorrelation::_get_zero_array($#$test_array) };

done_testing();
