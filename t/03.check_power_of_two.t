use utf8;
use strict;

use Statistics::PhaseOnlyCorrelation;

BEGIN {
    use Test::Most tests => 4;
}

lives_ok {Statistics::PhaseOnlyCorrelation->_check_power_of_two(2)};
lives_ok {Statistics::PhaseOnlyCorrelation->_check_power_of_two(1024)};
dies_ok  {Statistics::PhaseOnlyCorrelation->_check_power_of_two(1025)};
dies_ok  {Statistics::PhaseOnlyCorrelation->_check_power_of_two(-1)};

done_testing();
