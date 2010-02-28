package WWW::Futaba::Parser::Index;
use Any::Moose;

use Web::Scraper;
use UNIVERSAL::isa;

use WWW::Futaba::Parser::Thread;
use WWW::Futaba::Parser::Result::Index;

extends 'WWW::Futaba::Parser::Base';

has 'thread_parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser::Base',
    lazy_build => 1,
);

sub _build_thread_parser {
    my $self = shift;
    return WWW::Futaba::Parser::Thread->new(%$self);
}

sub _build_web_scraper {
    scraper {
        result->{contents} = [];

        process '//form[@action="futaba.php"]', sub {
            my $form = shift;

            push @{ result->{contents} }, [];

            foreach ($form->content_list) {
                if (ref && $_->tag eq 'hr') {
                    push @{ result->{contents} }, [];
                    next;
                }

                next if ref && $_->tag eq 'table' && ($_->attr('style') || $_->attr('align'));

                push @{ result->{contents}->[-1] }, ref() ? $_->clone : $_;
            }
        };

        pop @{ result->{contents} };
        result;
    };
}

1;
