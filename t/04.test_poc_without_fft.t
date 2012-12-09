#!perl

use utf8;
use strict;

use POSIX;
use Math::FFT;
use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::Number::Delta within => POSIX::FLT_EPSILON;
    use Test::Most tests => 4;
}

my ( $array1,     $array2,     $result );
my ( $array1_fft, $array2_fft, $result_fft );
my $got;

subtest 'Correlation same signal' => sub {
    $array1 = [ 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0 ];
    $array2 = [ 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0 ];
    $array1_fft = Math::FFT->new($array1);
    $array2_fft = Math::FFT->new($array2);
    $result =
      Statistics::PhaseOnlyCorrelation::poc_without_fft( $array1_fft->cdft(),
        $array2_fft->cdft() );
    $result_fft = Math::FFT->new($result);
    $got        = $result_fft->invcdft($result);
    delta_ok($got->[0],  1);
    delta_ok($got->[1],  0);
    delta_ok($got->[2],  -3.92523114670944e-17);
    delta_ok($got->[3],  0);
    delta_ok($got->[4],  5.55111512312578e-17);
    delta_ok($got->[5],  0);
    delta_ok($got->[6],  3.92523114670944e-17);
    delta_ok($got->[7],  0);
    delta_ok($got->[8],  0);
    delta_ok($got->[9],  0);
    delta_ok($got->[10], 3.92523114670944e-17);
    delta_ok($got->[11], 0);
    delta_ok($got->[12], 5.55111512312578e-17);
    delta_ok($got->[13], 0);
    delta_ok($got->[14], -3.92523114670944e-17);
    delta_ok($got->[15], 0);
};

subtest 'Correlation different signal' => sub {
    $array2 = [ 1, 0, -2, 0, 3, 0, -4, 0, 5, 0, -6, 0, 7, 0, -8, 0 ];
    $array2_fft = Math::FFT->new($array2);
    $result =
      Statistics::PhaseOnlyCorrelation::poc_without_fft( $array1_fft->cdft(),
        $array2_fft->cdft() );
    $result_fft = Math::FFT->new($result);
    $got        = $result_fft->invcdft($result);
    delta_ok($got->[0],  -0.25);
    delta_ok($got->[1],  0);
    delta_ok($got->[2],  0.603553390593274);
    delta_ok($got->[3],  0);
    delta_ok($got->[4],  -0.25); delta_ok($got->[5],  0);
    delta_ok($got->[6],  0.103553390593274);
    delta_ok($got->[7],  0);
    delta_ok($got->[8],  -0.25);
    delta_ok($got->[9],  0);
    delta_ok($got->[10], -0.103553390593274);
    delta_ok($got->[11], 0);
    delta_ok($got->[12], -0.25);
    delta_ok($got->[13], 0);
    delta_ok($got->[14], -0.603553390593274);
    delta_ok($got->[15], 0);
};

subtest 'Correlation similar signal' => sub {
    $array2 = [ 1.1, 0, 2, 0, 3.3, 0, 4, 0, 5.5, 0, 6, 0, 7.7, 0, 8, 0 ];
    $array2_fft = Math::FFT->new($array2);
    $result =
      Statistics::PhaseOnlyCorrelation::poc_without_fft( $array1_fft->cdft(),
        $array2_fft->cdft() );
    $result_fft = Math::FFT->new($result);
    $got        = $result_fft->invcdft($result);
    delta_ok($got->[0],  0.998032565636364);
    delta_ok($got->[1],  0);
    delta_ok($got->[2],  0.0366894970913469);
    delta_ok($got->[3],  0);
    delta_ok($got->[4],  -0.0233394555681124);
    delta_ok($got->[5],  0);
    delta_ok($got->[6],  0.0106622350554301);
    delta_ok($got->[7],  0);
    delta_ok($got->[8],  0.00140150322585453);
    delta_ok($got->[9],  0);
    delta_ok($got->[10], -0.0129069223836222);
    delta_ok($got->[11], 0);
    delta_ok($got->[12], 0.0239053867058937);
    delta_ok($got->[13], 0);
    delta_ok($got->[14], -0.0344448097631548);
    delta_ok($got->[15], 0);
};

subtest 'Give different length and die' => sub {
    $array2 = [ 1, 0, 2, 0, 3, 0, 4, 0 ];
    $array2_fft = Math::FFT->new($array2);
    dies_ok {
        Statistics::PhaseOnlyCorrelation::poc_without_fft( $array1_fft->cdft(),
            $array2_fft->cdft() );
    };
};

done_testing();
