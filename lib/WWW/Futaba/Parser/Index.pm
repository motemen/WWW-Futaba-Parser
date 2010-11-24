package WWW::Futaba::Parser::Index;
use strict;
use warnings;
use base 'WWW::Futaba::Parser';
use WWW::Futaba::Parser::Result::Index;
use WWW::Futaba::Parser::Thread;

sub parse_string {
    my ($class, $string) = @_;

    my ($threads) = $string =~ m#<form action="futaba\.php\b[^>]*>(.+)#s
        or die "Could not parse: $string";

    my @threads = map { WWW::Futaba::Parser::Thread->parse_string($_) } $threads =~ m#(.+?<blockquote>.+?)<hr>#gs;

    return WWW::Futaba::Parser::Result::Index->new(
        threads => \@threads,
    );
}

1;
