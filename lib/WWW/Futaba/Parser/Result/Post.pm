package WWW::Futaba::Parser::Result::Post;
use Any::Moose;
use DateTime;

extends 'WWW::Futaba::Parser::Result';

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
    $text =~ s/ +//; # trim
    return $text;
}

sub info_string {
    my $self = shift;
    return join '', map $_->string_value, $self->tree->findnodes('table//td[2]/text() | table//td[2]/a[starts-with(@href, "mailto:")]/text()');
}

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

1;
