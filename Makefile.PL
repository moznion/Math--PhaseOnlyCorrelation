use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Statistics::PhaseOnlyCorrelation',
    AUTHOR              => 'moznion <moznion@gmail.com>',
    VERSION_FROM        => 'lib/Statistics/PhaseOnlyCorrelation.pm',
    ABSTRACT_FROM       => 'lib/Statistics/PhaseOnlyCorrelation.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Statistics-PhaseOnlyCorrelation-*' },
);
