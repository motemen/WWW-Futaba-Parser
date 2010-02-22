package WWW::Futaba::Parser;
use strict;
use warnings;
use WWW::Futaba::Parser::Result::Index;
use Web::Scraper;

our $VERSION = '0.01';

sub new { __PACKAGE__ }

sub parse_index {
    my ($self, $content) = @_;
    my $result = $self->index_scraper->scrape($content);
    return WWW::Futaba::Parser::Result::Index->new($result);
}

sub index_scraper {
    scraper {
        result->{threads} = [];

        process '//form[@action="futaba.php"]', sub {
            my $form = shift;

            push @{ result->{threads} }, [];

            foreach ($form->content_list) {
                if (ref && $_->tag eq 'hr') {
                    push @{ result->{threads} }, [];
                    next;
                }

                next if ref && $_->tag eq 'table' && ($_->attr('style') || $_->attr('align'));
                next unless @{ result->{threads} };

                push @{ result->{threads}->[-1] }, ref() ? $_->clone : $_;
            }
        };

        pop @{ result->{threads} };
        result;
    };
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
