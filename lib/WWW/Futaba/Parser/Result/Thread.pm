package WWW::Futaba::Parser::Result::Thread;
use Any::Moose;
use WWW::Futaba::Parser::Result::Post;
use HTML::TreeBuilder::XPath;
use URI;

extends 'WWW::Futaba::Parser::Result';

has 'posts', (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
    lazy_build => 1,
);

sub image_link_elem {
    my $self = shift;
    return $self->tree->findnodes('a/img/..')->[0];
}

sub link_elem {
    my $self = shift;
    return $self->tree->findnodes('a[not(@class="del")][not(@target)]')->[0];
}

sub uri {
    my $self = shift;
    return $self->make_uri($self->link_elem->attr('href'));
}

sub image_uri {
    my $self = shift;
    return $self->make_uri($self->image_link_elem->attr('href'));
}

sub thumbnail_uri {
    my $self = shift;
    return $self->make_uri($self->image_link_elem->find('img')->attr('src'));
}

sub _build_posts {
    my $self = shift;
    return [ map { $self->make_new_post($_) } $self->tree->findnodes('//table') ];
}

sub make_new_post {
    my ($self, $content) = @_;
    return WWW::Futaba::Parser::Result::Post->new(
        contents => [ $content ],
        parser   => $self->parser->post_parser,
    );
}

1;
