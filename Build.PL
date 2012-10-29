use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Statistics::PhaseOnlyCorrelation',
    license             => 'artistic2',
    dist_author         => 'moznion <moznion@gmail.com>',
    dist_version_from   => 'lib/Statistics/PhaseOnlyCorrelation.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Statistics-PhaseOnlyCorrelation-*' ],
);

$builder->create_build_script();
