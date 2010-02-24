package WWW::Futaba::Parser::Index;
use Any::Moose;
use Web::Scraper;
use UNIVERSAL::isa;

use WWW::Futaba::Parser::Thread;
use WWW::Futaba::Parser::Result::Index;

extends 'WWW::Futaba::Parser';

has 'thread_parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser',
    lazy_build => 1,
);

sub _build_thread_parser {
    my $self = shift;
    return WWW::Futaba::Parser::Thread->new(%$self);
}

sub parse {
    my ($self, $target) = @_;
    if (UNIVERSAL::isa($target, 'HTTP::Response')) {
        $self->base($target->base);
    } else {
        $target = URI->new($target) unless UNIVERSAL::isa($target, 'URI');
        $self->base($target);
    }
    my $result = $self->index_scraper->scrape($target);
    return WWW::Futaba::Parser::Result::Index->new(
        contents => $result->{contents},
        parser   => $self,
    );
}

sub index_scraper {
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
