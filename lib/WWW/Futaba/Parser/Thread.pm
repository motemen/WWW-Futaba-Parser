package WWW::Futaba::Parser::Thread;
use Any::Moose;

use WWW::Futaba::Parser::Post;

extends 'WWW::Futaba::Parser';

has 'post_parser', (
    is  => 'rw',
    isa => 'WWW::Futaba::Parser',
    lazy_build => 1,
);

sub _build_post_parser {
    my $self = shift;
    return WWW::Futaba::Parser::Post->new(%$self);
}

sub body_node {
    my ($self, $tree) = @_;
    return $tree->findnodes('blockquote')->[0];
}

sub body {
    my ($self, $tree) = @_;

    my $text = '';
    my $node = $self->body_node($tree);
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

sub info_nodes {
    my ($self, $tree) = @_;
    return $tree->findnodes(
        'input[@type="checkbox"]/following-sibling::text() | input[@type="checkbox"]/following-sibling::a[starts-with(@href, "mailto:")]/text()'
    );
}

sub info_string {
    my ($self, $tree) = @_;
    return join '', map $_->string_value, $self->info_nodes($tree);
}

sub info {
    my ($self, $tree) = @_;
    my $string = $self->info_string($tree);
    my ($year, $month, $day, $hour, $minute, $second, $no) = $string =~ m<(\d\d)/(\d\d)/(\d\d).*(\d\d):(\d\d):(\d\d)\s+No\.(\d+)>;
    return {
        datetime => DateTime->new(
            year => "20$year", month => $month, day => $day,
            hour => $hour, minute => $minute, second => $second,
        ),
        no => $no,
    };
}

1;
