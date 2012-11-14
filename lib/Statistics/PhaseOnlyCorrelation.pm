package Statistics::PhaseOnlyCorrelation;

use warnings;
use strict;
use Carp;
use Math::FFT;
use List::MoreUtils qw/mesh/;
use Data::Dumper;

our $VERSION = '0.01';

sub _poc {
    my ($self, $f, $g, $length) = @_;

    my $result;
    for (my $i = 0; $i <= $length; $i += 2) {
        my $f_abs = sqrt($f->[$i] * $f->[$i] + $f->[$i+1] * $f->[$i+1]);
        my $g_abs = sqrt($g->[$i] * $g->[$i] + $g->[$i+1] * $g->[$i+1]);
        my $f_real  = $f->[$i]   / $f_abs;
        my $f_image = $f->[$i+1] / $f_abs;
        my $g_real  = $g->[$i]   / $g_abs;
        my $g_image = $g->[$i+1] / $g_abs;
        $result->[$i]   = ($f_real * $g_real + $f_image * $g_image);
        $result->[$i+1] = ($f_image * $g_real - $f_real * $g_image);
    }
    return $result;
}

sub _get_zero_array {
    my ($self, $length) = @_;

    croak "$!" if $length <= -1;

    my $array;
    $array->[$_] = 0 for 0 .. $length;
    return $array;
}

sub poc_without_fft {
    my ($self, $f, $g) = @_;

    (my $length, $f, $g) = $self->_adjust_array_length($f, $g);
    $self->_check_power_of_two($length + 1);

    return $self->_poc($f, $g, $length);
}

sub poc {
    my ($self, $ref_f, $ref_g) = @_;

    my @f = @{$ref_f};
    my @g = @{$ref_g};

    my $f_image_array = $self->_get_zero_array($#$ref_f);
    my $g_image_array = $self->_get_zero_array($#$ref_g);
    @f = mesh(@f, @$f_image_array);
    @g = mesh(@g, @$g_image_array);

    # TODO validate array doesn't have 'undef' element

    my $f_fft = Math::FFT->new(\@f);
    my $g_fft = Math::FFT->new(\@g);

    my $result = $self->poc_without_fft($f_fft->cdft(), $g_fft->cdft());
    my $result_fft = Math::FFT->new($result);

    return $result_fft->invcdft($result);
}

sub _format_array {
    my ($self, $longer, $shorter) = @_;
    return ($#$longer, $self->_zero_fill($shorter, $#$longer));
}

sub _adjust_array_length {
    my ($self, $array1, $array2) = @_;

    my $length = -1;
    if ($#$array1 == $#$array2) {
        $length = $#$array1;
    } elsif ($#$array1 > $#$array2) {
        ($length, $array2) = $self->_format_array($array1, $array2);
    } else {
        ($length, $array1) = $self->_format_array($array2, $array1);
    }

    return ($length, $array1, $array2);
}

sub _zero_fill {
    my ($self, $array, $max) = @_;

    my @array = @{$array};
    $array[$_] = 0 for ($#$array+1)..($max);

    return \@array;
}

sub _check_power_of_two {
    my ($self, $num) = @_;

    for (my $i = 0; ($num != 2 ** $i); $i++) {
        croak "Array length must be a power of two." if $num < 2 ** $i;
    }
}
1;

__END__

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;


# Module implementation here


1; # Magic true value required at end of module
__END__

=head1 NAME

Statistics::PhaseOnlyCorrelation - [One line description of module's purpose here]


=head1 VERSION

This document describes Statistics::PhaseOnlyCorrelation version 0.0.1


=head1 SYNOPSIS

    use Statistics::PhaseOnlyCorrelation;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

Statistics::PhaseOnlyCorrelation requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-statistics-phaseonlycorrelation@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

moznion  C<< <moznion@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, moznion C<< <moznion@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
