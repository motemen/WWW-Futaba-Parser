package WWW::Futaba::Parser::Post;
use Any::Moose;

extends 'WWW::Futaba::Parser::Thread';

sub body_node {
    my ($self, $tree) = @_;
    return $tree->findnodes('table//blockquote')->[0];
};

sub head_nodes {
    my ($self, $tree) = @_;
    return $tree->findnodes(
        'table//td[2]/text() | table//td[2]/a[starts-with(@href, "mailto:")]/text()'
    );
}

sub head_title_and_author {
    my ($self, $tree) = @_;
    return map $_->string_value, $tree->findnodes('table//font/b//text()');
}

1;
