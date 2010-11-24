package WWW::Futaba::Parser::Index;
use strict;
use warnings;
use base 'WWW::Futaba::Parser';
use WWW::Futaba::Parser::Result::Index;
use WWW::Futaba::Parser::Thread;
use Carp;

sub parse_string {
    my ($class, $string) = @_;

    my ($threads) = $string =~ m#<form action="futaba\.php"[^>]*>(.+)#s or croak;

    my @threads = map { WWW::Futaba::Parser::Thread->parse_string($_) } $threads =~ m#(.+?)<hr>#gs;

    return WWW::Futaba::Parser::Result::Index->new(
        threads => \@threads,
    );
}

1;
