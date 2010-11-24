package WWW::Futaba::Parser;
use strict;
use warnings;
use URI;
use Scalar::Util qw(blessed);

our $VERSION = '0.01';

sub parser_for_url {
    my ($class, $url) = @_;

    $url = URI->new($url) unless blessed $url;

    if ($url->path =~ m(^/\w+/res/\d+\.htm$)) {
        require WWW::Futaba::Parser::Thread;
        return 'WWW::Futaba::Parser::Thread';
    } elsif ($url->path =~ m(^/\w+/futaba\.php)) {
        require WWW::Futaba::Parser::Catalog;
        return 'WWW::Futaba::Parser::Catalog';
    } elsif ($url->path =~ m(^/\w+/)) {
        require WWW::Futaba::Parser::Index;
        return 'WWW::Futaba::Parser::Index';
    }
}

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

    use WWW::Futaba::Parser;
    my $thread = WWW::Futaba::Parser->parser_for_url($thread_url)->parse($html);
    foreach my $post ($thread->posts) {
        say $post->body;
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
