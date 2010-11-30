package WWW::Futaba::Parser::Result::Catalog;
use Any::Moose;

use WWW::Futaba::Parser::Result::Thread;

has 'threads', (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
    lazy_build => 1,
);

sub _build_threads {
    my $self = shift;
    return [ map { $self->make_new_thread($_) } $self->tree->findnodes('//td') ];
}

sub make_new_thread {
    my ($self, $content) = @_;
    # TODO
    undef;
}

1;
