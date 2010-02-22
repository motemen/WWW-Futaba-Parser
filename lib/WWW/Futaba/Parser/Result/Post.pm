package WWW::Futaba::Parser::Result::Post;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
use HTML::TreeBuilder::XPath;
use HTML::Entities;
use DateTime;

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

sub body {
    my $self = shift;

    my $text = '';
    my $node = $self->tree->findnodes('table//blockquote')->[0];
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
    return $text;
}

sub meta_string {
    my $self = shift;
    return join '', map $_->string_value, $self->tree->findnodes('table//td[2]/text() | table//td[2]/a[starts-with(@href, "mailto:")]/text()');
}

sub meta {
    my $self = shift;
    my $string = $self->meta_string;
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
