#!/usr/bin/env perl

use 5.16.0;
use strict;
use warnings;
use Math::FFT;
use List::MoreUtils qw/zip/;
use Data::Dumper;

use FindBin;
use lib ("$FindBin::Bin/../../lib");

use Statistics::PhaseOnlyCorrelation;

my $hoge = [1,2,3,4,5,6,7,8];
my $fuga = [1,-2,3,-4,5,-6,7,-8];

my $result = Statistics::PhaseOnlyCorrelation->poc($hoge, $fuga);
