package WWW::Futaba::Parser::Thread;
use strict;
use warnings;
use base 'WWW::Futaba::Parser';
use WWW::Futaba::Parser::Result::Thread;
use WWW::Futaba::Parser::Result::Post;
use Carp;

sub parse_string {
    my ($class, $string) = @_;

    $string =~ s/<form action="futaba\.php"[^>]*>//;

    my ($meta, $body, $posts) = $string =~ m#<input type=checkbox[^>]*>(.+?)<blockquote>(.+?) ?</blockquote>(.+)#s or croak 'Could not parse';

    # TODO 共通化
    my ($date, $no)      = $meta =~ m#(\d\d/\d\d/\d\d.*?\d\d:\d\d:\d\d)\s+No\.(\d+)#;
    my ($title, $author) = $meta =~ m|<font color=#cc1105[^>]*><b>(.*?)</b></font>.*?<font color=#117743[^>]*><b>(.*?) ?</b>|s;

    for ($body) {
        s/<br>/\n/g;
        s/<[^>]*>//g;
        s/&lt;/</g;
        s/&gt;/>/g;
        s/&quot;/"/g;
        s/&amp;/&/g;
    }

    my @posts = map { $class->parse_post_string($_) } $posts =~ m#<table border=0>(.+?)</table>#gs;

    return WWW::Futaba::Parser::Result::Thread->new(
        body => $body,
        head => {
            date   => $date,
            no     => $no,
            author => $author,
            title  => $title,
        },
        posts  => \@posts,
    );
}

sub parse_post_string {
    my ($class, $string) = @_;

    my ($meta, $body, $posts) = $string =~ m#<input type=checkbox[^>]*>(.+?)<blockquote>(.+?) ?</blockquote>(.+)#s or croak "Could not parse: $string";

    my ($date, $no)      = $meta =~ m#(\d\d/\d\d/\d\d.*?\d\d:\d\d:\d\d)(?:</a>)?\s+No\.(\d+)# or die "Could not parse: $meta";
    my ($title, $author) = $meta =~ m|<font color=#cc1105[^>]*><b>(.*?)</b></font>.*?<font color=#117743[^>]*><b>.*?<b>(.*?) ?</b>|s;
    my ($mail)           = $meta =~ /<a href="mailto:([^"]+)"[^>]*?>/;

    for ($body) {
        s/<br>/\n/g;
        s/<[^>]*>//g;
        s/&lt;/</g;
        s/&gt;/>/g;
        s/&quot;/"/g;
        s/&amp;/&/g;
    }

    return WWW::Futaba::Parser::Result::Post->new(
        body => $body,
        head => {
            date   => $date,
            no     => $no,
            mail   => $mail,
            title  => $title,
            author => $author,
        },
    );
}

1;
