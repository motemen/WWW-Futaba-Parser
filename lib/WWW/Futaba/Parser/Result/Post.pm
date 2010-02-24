package WWW::Futaba::Parser::Result::Post;
use Any::Moose;
use DateTime;

extends 'WWW::Futaba::Parser::Result';

sub body {
    my $self = shift;
    $self->parser->body($self->tree);
}

sub info {
    my $self = shift;
    $self->parser->info($self->tree);
}

1;
