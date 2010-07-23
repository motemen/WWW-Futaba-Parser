package WWW::Futaba::Parser::Result;
use Any::Moose;
use URI;

has 'parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser::Base',
    required => 1,
);

has 'contents', (
    is  => 'rw',
    isa => 'ArrayRef',
    auto_deref => 1,
);

has 'parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser::Base',
);

has 'tree', (
    is  => 'rw',
    isa => 'HTML::TreeBuilder::XPath',
    lazy_build => 1,
);

has 'head', (
    is  => 'rw',
    isa => 'HashRef',
    lazy_build => 1,
);

has 'body', (
    is  => 'rw',
    isa => 'Str',
    lazy_build => 1,
);

__PACKAGE__->meta->make_immutable;

sub _build_tree {
    my $self = shift;
    my $t = HTML::TreeBuilder::XPath->new;
    $t->push_content($self->contents);
    return $t;
}

sub _build_body {
    shift->call_parser('body');
}

sub _build_head {
    shift->call_parser('head');
}

sub make_uri {
    my ($self, $node) = @_;
    my $uri;
    if (not ref $node) {
        $uri = $node;
    } elsif ($node->tag eq 'a') {
        $uri = $node->attr('href');
    } elsif ($node->tag eq 'img') {
        $uri = $node->attr('src');
    }
    return $uri && URI->new_abs($uri, $self->parser->base);
}

sub call_parser {
    my ($self, $method) = @_;
    return $self->parser->$method($self->tree);
}

sub DEMOLISH {
    my $self = shift;
    if ($self->tree) {
        $self->tree->delete;
    }
    foreach ($self->contents) {
        if (blessed $_ && $_->can('delete')) {
            $_->delete;
        }
    }
}

1;
