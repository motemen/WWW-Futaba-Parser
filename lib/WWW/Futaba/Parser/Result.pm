package WWW::Futaba::Parser::Result;
use Any::Moose;
use URI;

has 'parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser',
    required => 1,
);

has 'contents', (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
);

has 'parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser',
);

has 'tree', (
    is  => 'rw',
    isa => 'HTML::TreeBuilder::XPath',
    lazy_build => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

sub _build_tree {
    my $self = shift;
    my $t = HTML::TreeBuilder::XPath->new;
    $t->push_content($self->contents);
    return $t;
}

sub make_uri {
    my ($self, $uri) = @_;
    return URI->new_abs($uri, $self->parser->base);
}

sub call_parser {
    my ($self, $method) = @_;
    return $self->parser->$method($self->tree);
}

1;
