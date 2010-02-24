package WWW::Futaba::Parser::Result::Index;
use Any::Moose;
use WWW::Futaba::Parser::Result::Thread;

extends 'WWW::Futaba::Parser::Result';

has 'threads', (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
    lazy_build => 1,
);

sub _build_threads {
    my $self = shift;
    return [ map { $self->make_new_thread($_) } $self->contents ];
}

sub make_new_thread {
    my ($self, $contents) = @_;
    return WWW::Futaba::Parser::Result::Thread->new(contents => $contents);
}

1;
