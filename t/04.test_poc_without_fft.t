use utf8;
use strict;

use Math::FFT;
use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::More tests => 3;
}

my $array1;
my $array2;
my $result;
my $array1_fft;
my $array2_fft;
my $result_fft;
my $got;

$array1 = [1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0];
$array2 = [1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0];
$array1_fft = Math::FFT->new($array1);
$array2_fft = Math::FFT->new($array2);
$result = Statistics::PhaseOnlyCorrelation->poc_without_fft($array1_fft->cdft(), $array2_fft->cdft());
$result_fft = Math::FFT->new($result);
$got = $result_fft->invcdft($result);
is_deeply ($got, [1, 0, -3.92523114670944e-17, 0, 5.55111512312578e-17, 0, 3.92523114670944e-17, 0, 0, 0, 3.92523114670944e-17, 0, 5.55111512312578e-17,0, -3.92523114670944e-17,0]);

$array2 = [1,0,-2,0,3,0,-4,0,5,0,-6,0,7,0,-8,0];
$array2_fft = Math::FFT->new($array2);
$result = Statistics::PhaseOnlyCorrelation->poc_without_fft($array1_fft->cdft(), $array2_fft->cdft());
$result_fft = Math::FFT->new($result);
$got = $result_fft->invcdft($result);
is_deeply ($got, [-0.25, 0, 0.603553390593274, 0, -0.25, 0, 0.103553390593274, 0, -0.25, 0, -0.103553390593274, -0, -0.25, 0, -0.603553390593274, 0]);

$array2 = [1.1,0,2,0,3.3,0,4,0,5.5,0,6,0,7.7,0,8,0];
$array2_fft = Math::FFT->new($array2);
$result = Statistics::PhaseOnlyCorrelation->poc_without_fft($array1_fft->cdft(), $array2_fft->cdft());
$result_fft = Math::FFT->new($result);
$got = $result_fft->invcdft($result);
is_deeply ($got, [0.998032565636364, 0, 0.0366894970913469, 0, -0.0233394555681124, 0, 0.0106622350554301, 0, 0.00140150322585453, 0, -0.0129069223836222, 0, 0.0239053867058937, 0, -0.0344448097631548, 0]);

done_testing();
