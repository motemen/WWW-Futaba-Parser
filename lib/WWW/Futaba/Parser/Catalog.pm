package WWW::Futaba::Parser::Catalog;
use Any::Moose;

use Web::Scraper;

extends 'WWW::Futaba::Parser::Base';

sub _build_web_scraper {
    scraper {
        result->{contents} = [];
        process '//td', sub {
            my $td = shift;
            push @{ result->{contents} }, $td->clone;
        };
        result;
    };
}

1;
