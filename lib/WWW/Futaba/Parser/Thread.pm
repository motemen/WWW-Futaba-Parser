package WWW::Futaba::Parser::Thread;
use Any::Moose;

use Web::Scraper;

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

sub head_nodes {
    my ($self, $tree) = @_;
    return $tree->findnodes(
        'input[@type="checkbox"]/following-sibling::text() | input[@type="checkbox"]/following-sibling::a[starts-with(@href, "mailto:")]/text()'
    );
}

sub head_string {
    my ($self, $tree) = @_;
    return join '', map $_->string_value, $self->head_nodes($tree);
}

sub head {
    my ($self, $tree) = @_;

    my ($title, $name) = map $_->string_value, $tree->findnodes('font/b/text()');
    $name =~ s/ $// if $name;

    my $string = $self->head_string($tree);
    my ($year, $month, $day, $hour, $minute, $second, $no) = $string =~ m<(\d\d)/(\d\d)/(\d\d).*(\d\d):(\d\d):(\d\d)\s+No\.(\d+)>;
    return {
        datetime => DateTime->new(
            year => "20$year", month => $month, day => $day,
            hour => $hour, minute => $minute, second => $second,
            time_zone => 'Asia/Tokyo',
        ),
        no    => $no,
        title => $title,
        name  => $name,
    };
}

sub mail {
    my ($self, $tree) = @_;
    my $mail = $tree->findnodes_as_string(
        'table//a[@href][1]/@href'
    );
    $mail =~ s/^\s*href="(.+)"$/$1/;
    $mail =~ s/^mailto://;
    return $mail;
}

sub _build_web_scraper {
    scraper {
        process '//form[@action="futaba.php"]', sub {
            my $form = shift;
            result->{contents} = [ map { ref() ? $_->clone : $_ } $form->content_list ]
        };
        result;
    };
}

1;
