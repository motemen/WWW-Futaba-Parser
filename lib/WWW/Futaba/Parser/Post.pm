package WWW::Futaba::Parser::Post;
use Any::Moose;

extends 'WWW::Futaba::Parser::Thread';

sub body_node {
    my ($self, $tree) = @_;
    return $tree->findnodes('table//blockquote')->[0];
};

sub info_nodes {
    my ($self, $tree) = @_;
    return $tree->findnodes(
        'table//td[2]/text() | table//td[2]/a[starts-with(@href, "mailto:")]/text()'
    );
}

1;
