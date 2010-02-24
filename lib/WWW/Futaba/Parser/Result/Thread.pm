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
    return $self->link_elem->attr('href');
}

sub image_uri {
    my $self = shift;
    return $self->image_link_elem->attr('href');
}

sub thumbnail_uri {
    my $self = shift;
    return $self->image_link_elem->find('img')->attr('src');
}

# TODO
sub body {
    my $self = shift;
    my $text = '';
    my $node = $self->tree->findnodes('blockquote')->[0];
    for (my @nodes; $node; $node = shift @nodes) {
        if (!defined $node) {
        } elsif (!ref $node) {
            $text .= $node;
        } elsif ($node->tag eq 'br') {
            $text .= "\n";
        } else {
            unshift @nodes, $node->content_list;
        }
    }
    $text =~ s/ +//; # trim
    return $text;
}

sub info_string {
    my $self = shift;
    return join '', map $_->string_value, $self->tree->findnodes('input[@type="checkbox"]/following-sibling::text() | input[@type="checkbox"]/following-sibling::a[starts-with(@href, "mailto:")]/text()');
}

# XXX
sub info {
    my $self = shift;
    my $string = $self->info_string;
    my ($year, $month, $day, $hour, $minute, $second, $no) = $string =~ m<(\d\d)/(\d\d)/(\d\d).*(\d\d):(\d\d):(\d\d)\s+No\.(\d+)>;
    return {
        datetime => DateTime->new(
            year => "20$year", month => $month, day => $day,
            hour => $hour, minute => $minute, second => $second,
        ),
        no => $no,
    };
}

sub _build_posts {
    my $self = shift;
    return [ map { $self->make_new_post($_) } $self->tree->findnodes('table') ];
}

sub make_new_post {
    my ($self, $content) = @_;
    return WWW::Futaba::Parser::Result::Post->new(contents => [ $content ]);
}

1;
