package WWW::Futaba::Parser;
use Any::Moose;

use UNIVERSAL::isa;
use UNIVERSAL::require;
use URI;

has 'base', (
    is  => 'rw',
    isa => 'URI',
);

has 'web_scraper', (
    is  => 'rw',
    isa => 'Web::Scraper',
    lazy_build => 1,
);

has 'result_class', (
    is  => 'rw',
    isa => 'Str',
    lazy_build => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

our $VERSION = '0.01';

sub parse {
    my ($self, $target) = @_;
    if (UNIVERSAL::isa($target, 'HTTP::Response')) {
        $self->base($target->base);
    } else {
        $target = URI->new($target) unless UNIVERSAL::isa($target, 'URI');
        $self->base($target);
    }
    my $result = $self->web_scraper->scrape($target);
    $self->result_class->require or die $@;
    return $self->result_class->new(
        contents => $result->{contents},
        parser   => $self,
    );
}

sub _build_result_class {
    my $self = shift;
    my $class = ref $self || $self;
    $class =~ s/Parser::/Parser::Result::/;
    return $class;
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
