package WWW::Futaba::Parser;
use strict;
use warnings;
use URI;
use Scalar::Util qw(blessed);

sub parse {
    my ($class, $object) = @_;

    if (not ref $object) {
        return $class->parse_string($object);
    } elsif (ref $object eq 'SCALAR') {
        return $class->parse_string($$object);
    } elsif (blessed $object && $object->isa('HTTP::Message')) {
        return $class->parse_string($object->decoded_content);
    } else {
        die 'not implemented';
    }
}

sub parse_string {
    die 'not implemented';
}

1;

__END__

=head1 NAME

WWW::Futaba::Parser -

=head1 SYNOPSIS

  use WWW::Futaba::Parser;

=head1 DESCRIPTION

WWW::Futaba::Parser is

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
