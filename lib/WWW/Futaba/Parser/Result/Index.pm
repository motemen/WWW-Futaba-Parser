package WWW::Futaba::Parser::Result::Index;
use Any::Moose;

has threads => (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
    lazy_build => 1,
);

1;
