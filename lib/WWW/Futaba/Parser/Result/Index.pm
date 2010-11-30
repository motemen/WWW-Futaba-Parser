package WWW::Futaba::Parser::Result::Index;
use Any::Moose;
use URI;

has base => (
    is  => 'rw',
    isa => 'URI',
    default => sub { URI->new('http:') },
);

has threads => (
    is  => 'rw',
    isa => 'ArrayRef[WWW::Futaba::Parser::Result::Thread]',
    auto_deref => 1,
);

__PACKAGE__->meta->make_immutable;

1;
