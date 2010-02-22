package WWW::Futaba::Parser::Result::Thread;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
use WWW::Futaba::Parser::Result::Post;
use HTML::TreeBuilder::XPath;

__PACKAGE__->mk_accessors(
    qw(contents)
);

sub tree {
    my $self = shift;
    $self->{tree} ||= do {
        my $t = HTML::TreeBuilder::XPath->new;
        $t->push_content(@{$self->contents});
        $t;
    };
}

sub image_link_elem {
    my $self = shift;
    return $self->tree->findnodes('a/img/..')->[0];
}

sub link_elem {
    my $self = shift;
    return $self->tree->findnodes('a[not(@class="del")][not(@target)]')->[0];
}

sub url {
    my $self = shift;
    return $self->link_elem->attr('href');
}

sub posts {
    my $self = shift;
    return map { $self->make_new_post($_) } $self->tree->findnodes('table');
}

sub make_new_post {
    my ($self, $content) = @_;
    return WWW::Futaba::Parser::Result::Post->new({ contents => [ $content ] });
}

1;
