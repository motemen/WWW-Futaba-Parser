package WWW::Futaba::Parser::Base;
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
    return $self->result_class->new(
        contents => $result->{contents},
        parser   => $self,
    );
}

sub _build_result_class {
    my $self = shift;
    my $class = ref $self || $self;
    $class =~ s/Parser::/Parser::Result::/;
    $class->require or die $@;
    return $class;
}

1;
