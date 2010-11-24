package WWW::Futaba::Parser;
use strict;
use warnings;
use URI;
use Scalar::Util qw(blessed);

our $VERSION = '0.01';

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

WWW::Futaba::Parser - Parse 2chan.net HTML

=head1 SYNOPSIS

    use WWW::Futaba::Parser::Index;

    my $index = WWW::Futaba::Parser::Index->parse($ua->get('http://jun.2chan.net/b/'));
    foreach my $thread ($index->threads) {
        say $thread->body;
    }

=head1 DESCRIPTION

WWW::Futaba::Parser parses 2chan.net HTML. 
This module uses regular expression for parsing rather than HTML parser such as HTML::TreeBuilder,
which is not useful for broken HTMLs.

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
