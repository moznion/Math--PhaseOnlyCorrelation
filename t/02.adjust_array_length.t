use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::More tests => 11;
}

my ($got_length, $got_array1, $got_array2);

($got_length, $got_array1, $got_array2) = Statistics::PhaseOnlyCorrelation->_adjust_array_length([1,2,3,4], [1,2,3,4]);
is($got_length, 3);
is_deeply($got_array1, [1,2,3,4]);
is_deeply($got_array2, [1,2,3,4]);

($got_length, $got_array1, $got_array2) = Statistics::PhaseOnlyCorrelation->_adjust_array_length([1,2], [1,2,3,4]);
is($got_length, 3);
is_deeply($got_array1, [1,2,0,0]);
is_deeply($got_array2, [1,2,3,4]);

($got_length, $got_array1, $got_array2) = Statistics::PhaseOnlyCorrelation->_adjust_array_length([1,2,3,4], [1,2]);
is($got_length, 3);
is_deeply($got_array1, [1,2,3,4]);
is_deeply($got_array2, [1,2,0,0]);

my $test_array1 = [1,2,3,4];
my $test_array2 = [1,2];
($got_length, $got_array1, $got_array2) = Statistics::PhaseOnlyCorrelation->_adjust_array_length($test_array1, $test_array2);
is_deeply($test_array2, [1,2]);
is_deeply($got_array2, [1,2,0,0]);

done_testing();
