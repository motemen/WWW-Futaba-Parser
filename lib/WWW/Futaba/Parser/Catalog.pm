package WWW::Futaba::Parser::Catalog;
use strict;
use warnings;
use base 'WWW::Futaba::Parser';
use WWW::Futaba::Parser::Result::Catalog;
use WWW::Futaba::Parser::Result::Thread;

sub parse_string {
    my ($class, $string, $args) = @_;
    my @threads;
    while ($string =~ m#<td><a href=['"](res/\d+\.htm)['"][^>]*><img src=['"](.+?)['"][^>]*>(?:<[^>]+>)*(\d+)(?:<[^>]+>)*</td>#g) {
        push @threads, WWW::Futaba::Parser::Result::Thread->new(
            %$args,
            head => {
                path => $1,
                catalog_thumbnail_url => $2,
                posts_count => $3,
            }
        );
    }
    return WWW::Futaba::Parser::Result::Catalog->new(
        threads => \@threads
    );
}

1;
