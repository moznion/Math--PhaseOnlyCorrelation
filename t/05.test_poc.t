use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::Most tests => 6;
}

my ( $array1, $array2, $got );

subtest 'Give different length array' => sub {
    $array1 = [ 1, 2, 3, 4 ];
    $array2 = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
    lives_ok { Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 ) };
};

subtest 'Give not 2^n length array and die' => sub {
    $array1 = [ 1, 2, 3, 4, 5 ];
    $array2 = [ 1, 2, 3, 4, 5 ];
    dies_ok { Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 ) };
};

subtest 'Correlation same signal' => sub {
    $array1 = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
    $array2 = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    is_deeply(
        $got,
        [
            1,                    0, -3.92523114670944e-17, 0,
            5.55111512312578e-17, 0, 3.92523114670944e-17,  0,
            0,                    0, 3.92523114670944e-17,  0,
            5.55111512312578e-17, 0, -3.92523114670944e-17, 0
        ]
    );
};

subtest 'Correlation different signal' => sub {
    $array2 = [ 1, -2, 3, -4, 5, -6, 7, -8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    is_deeply(
        $got,
        [
            -0.25, 0, 0.603553390593274,  0,
            -0.25, 0, 0.103553390593274,  0,
            -0.25, 0, -0.103553390593274, -0,
            -0.25, 0, -0.603553390593274, 0
        ]
    );
};

subtest 'Correlation similar signal' => sub {
    $array2 = [ 1.1, 2, 3.3, 4, 5.5, 6, 7.7, 8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    is_deeply(
        $got,
        [
            0.998032565636364,   0, 0.0366894970913469,  0,
            -0.0233394555681124, 0, 0.0106622350554301,  0,
            0.00140150322585453, 0, -0.0129069223836222, 0,
            0.0239053867058937,  0, -0.0344448097631548, 0
        ]
    );
};

subtest 'Check non destructive' => sub {
    is_deeply( $array1, [ 1,   2, 3,   4, 5,   6, 7,   8 ] );
    is_deeply( $array2, [ 1.1, 2, 3.3, 4, 5.5, 6, 7.7, 8 ] );
};

done_testing();
