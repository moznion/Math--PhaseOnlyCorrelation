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
    done_testing();
};

subtest 'Give not 2^n length array and die' => sub {
    $array1 = [ 1, 2, 3, 4, 5 ];
    $array2 = [ 1, 2, 3, 4, 5 ];
    dies_ok { Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 ) };
    done_testing();
};

subtest 'Correlation same signal' => sub {
    $array1 = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
    $array2 = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    ok($got->[0] eq 1);
    ok(abs($got->[1]) eq 0);
    ok($got->[2] eq -3.92523114670944e-17);
    ok(abs($got->[3]) eq 0);
    ok($got->[4] eq 5.55111512312578e-17);
    ok(abs($got->[5]) eq 0);
    ok($got->[6] eq 3.92523114670944e-17);
    ok(abs($got->[7]) eq 0);
    ok($got->[8] eq 0);
    ok(abs($got->[9]) eq 0);
    ok($got->[10] eq 3.92523114670944e-17);
    ok(abs($got->[11]) eq 0);
    ok($got->[12] eq 5.55111512312578e-17);
    ok(abs($got->[13]) eq 0);
    ok($got->[14] eq -3.92523114670944e-17);
    ok(abs($got->[15]) eq 0);
    done_testing();
};

subtest 'Correlation different signal' => sub {
    $array2 = [ 1, -2, 3, -4, 5, -6, 7, -8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    ok($got->[0] eq -0.25);
    ok(abs($got->[1]) eq 0);
    ok($got->[2] eq 0.603553390593274);
    ok(abs($got->[3]) eq 0);
    ok($got->[4] eq -0.25);
    ok(abs($got->[5]) eq 0);
    ok($got->[6] eq 0.103553390593274);
    ok(abs($got->[7]) eq 0);
    ok($got->[8] eq -0.25);
    ok(abs($got->[9]) eq 0);
    ok($got->[10] eq -0.103553390593274);
    ok(abs($got->[11]) eq 0);
    ok($got->[12] eq -0.25);
    ok(abs($got->[13]) eq 0);
    ok($got->[14] eq -0.603553390593274);
    ok(abs($got->[15]) eq 0);
    done_testing();
};

subtest 'Correlation similar signal' => sub {
    $array2 = [ 1.1, 2, 3.3, 4, 5.5, 6, 7.7, 8 ];
    $got = Statistics::PhaseOnlyCorrelation::poc( $array1, $array2 );
    ok($got->[0] eq 0.998032565636364);
    ok(abs($got->[1]) eq 0);
    ok($got->[2] eq 0.0366894970913469);
    ok(abs($got->[3]) eq 0);
    ok($got->[4] eq -0.0233394555681124);
    ok(abs($got->[5]) eq 0);
    ok($got->[6] eq 0.0106622350554301);
    ok(abs($got->[7]) eq 0);
    ok($got->[8] eq 0.00140150322585453);
    ok(abs($got->[9]) eq 0);
    ok($got->[10] eq -0.0129069223836222);
    ok(abs($got->[11]) eq 0);
    ok($got->[12] eq 0.0239053867058937);
    ok(abs($got->[13]) eq 0);
    ok($got->[14] eq -0.0344448097631548);
    ok(abs($got->[15]) eq 0);
    done_testing();
};

subtest 'Check non destructive' => sub {
    is_deeply( $array1, [ 1,   2, 3,   4, 5,   6, 7,   8 ] );
    is_deeply( $array2, [ 1.1, 2, 3.3, 4, 5.5, 6, 7.7, 8 ] );
    done_testing();
};

done_testing();
