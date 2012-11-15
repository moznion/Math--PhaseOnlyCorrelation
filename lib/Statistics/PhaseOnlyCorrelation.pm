package Statistics::PhaseOnlyCorrelation;

use warnings;
use strict;
use Carp;
use Math::FFT;
use List::MoreUtils qw/mesh/;

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

=head1 NAME

Statistics::PhaseOnlyCorrelation - calculate the phase only correlation


=head1 VERSION

This document describes Statistics::PhaseOnlyCorrelation version 0.0.1


=head1 SYNOPSIS

    use Statistics::PhaseOnlyCorrelation;

    my $array1 = [1,2,3,4,5,6,7,8];
    my $array2 = [1,2,3,4,5,6,7,8];

    my $result = Statistics::PhaseOnlyCorrelation->poc($array1, $array2);

Or if you want to use own FFT function, you may use like so:

    use Math::FFT;
    use List::MoreUtils qw/mesh/;
    use Statistics::PhaseOnlyCorrelation;

    my @array1 = (1, 2, 3, 4, 5, 6, 7, 8);
    my @array2 = (1, 2, 3, 4, 5, 6, 7, 8);
    my @zero_array = (0, 0, 0, 0, 0, 0, 0, 0); # <= imaginary components

    @array1 = mesh(@array1, @zero_array);
    @array2 = mesh(@array2, @zero_array);

    my $array1_fft = Math::FFT->new(\@array1);
    my $array2_fft = Math::FFT->new(\@array2);
    my $result = Statistics::PhaseOnlyCorrelation->poc_without_fft($array1_fft->cdft(), $array2_fft->cdft());

    my $ifft = Math::FFT->new($result);
    $result = $ifft->invcdft($result);


=head1 DESCRIPTION

    This module calculate Phase Only Correlation coefficients.


=head1 METHODS

=over

=item poc

=item poc_without_fft

=back


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

Statistics::PhaseOnlyCorrelation requires no configuration files or environment variables.


=head1 DEPENDENCIES

=item Math::FFT (Version 1.28 or later)

=item List::MoreUtils (Version 0.33 or later)


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

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
