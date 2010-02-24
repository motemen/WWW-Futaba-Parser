package WWW::Futaba::Parser::Result;
use Any::Moose;

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

sub _build_tree {
    my $self = shift;
    my $t = HTML::TreeBuilder::XPath->new;
    $t->push_content($self->contents);
    return $t;
}

__PACKAGE__->meta->make_immutable;

1;
