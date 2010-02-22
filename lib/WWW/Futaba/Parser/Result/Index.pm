package WWW::Futaba::Parser::Result::Index;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
use WWW::Futaba::Parser::Result::Thread;

__PACKAGE__->mk_accessors(
    qw(threads)
);

sub threads {
    my $self = shift;

    unless (@_) {
        return map { $self->make_new_thread($_) } @{ $self->_threads_accessor || [] };
    }

    return $self->_threads_accessor(@_);
}

sub make_new_thread {
    my ($self, $contents) = @_;
    return WWW::Futaba::Parser::Result::Thread->new({ contents => $contents });
}

1;
