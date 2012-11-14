#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib ("$FindBin::Bin/../lib");
use Statistics::PhaseOnlyCorrelation;

my $array1 = [1,2,3,4,5,6,7,8];
my $array2 = [1,2,3,4,5,6,7,8];

my $result = Statistics::PhaseOnlyCorrelation->poc($array1, $array2);
