package WWW::Futaba::Parser::Result::Post;
use Any::Moose;
use DateTime;

extends 'WWW::Futaba::Parser::Result';

sub mail {
    shift->call_parser('mail');
}

sub image_link_node {
    my $self = shift;
    return $self->tree->findnodes('//a/img/..')->[0];
}

sub image_uri {
    my $self = shift;
    return $self->make_uri($self->image_link_node->attr('href'));
}

sub thumbnail_uri {
    my $self = shift;
    return $self->make_uri($self->image_link_node->find('img')->attr('src'));
}

1;
