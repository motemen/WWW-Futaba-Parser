package WWW::Futaba::Parser::Result::Catalog;
use Any::Moose;

use WWW::Futaba::Parser::Result::Thread;

has 'threads', (
    is  => 'rw',
    isa => 'ArrayRef[WWW::Futaba::Parser::Result::Thread]',
    auto_deref => 1,
    lazy_build => 1,
);

__PACKAGE__->meta->make_immutable;

sub _build_threads {
    my $self = shift;
    return [ map { $self->make_new_thread($_) } $self->tree->findnodes('//td') ];
}

1;
