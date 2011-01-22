package WWW::Futaba::Parser::Thread;
use strict;
use warnings;
use utf8;
use base 'WWW::Futaba::Parser';
use WWW::Futaba::Parser::Result::Thread;
use WWW::Futaba::Parser::Result::Post;

sub _to_plain_string {
    for (@_) {
        next unless defined $_;
        s/<br>/\n/g;
        s/<[^>]*>//g;
        s/&lt;/</g;
        s/&gt;/>/g;
        s/&quot;/"/g;
        s/&amp;/&/g;
    }
}

sub parse_string {
    my ($class, $string, $args) = @_;

    $string =~ s/^.*<form action="futaba\.php(?:[^>]*)>//s
        or warn 'Cutoff failed';

    my ($meta, $body, $posts) =
        $string =~ m#([[:print:]]+?<input type=checkbox[^>]*>.+?)<blockquote>(.+?) ?</blockquote>(.+)#s
            or die "Could not parse: $string";

    my %meta = $class->parse_meta_string($meta);

    _to_plain_string $body;

    my @posts = map { $class->parse_post_string($_) } $posts =~ m#<table border=0>(.+?)</table>#gs;
    return WWW::Futaba::Parser::Result::Thread->new(
        %$args,
        body  => $body,
        head  => \%meta,
        posts => \@posts,
    );
}

sub parse_meta_string {
    my ($class, $string) = @_;

    # required
    my ($date, $no) =
        $string =~ m#(\d\d/\d\d/\d\d.*?\d\d:\d\d:\d\d)(?:</a>)?(?:<!--.*?-->|\s)+No\.(\d+)# or die "Could not parse date, no.: $string";

    # not required
    my ($title, $author) =
        $string =~ m|<font color=#cc1105[^>]*><b>(.*?)</b></font>.*?<font color=#117743[^>]*><b>.*?([^<>]*?) ?</b>|s;
    my ($mail) =
        $string =~ /<a href="mailto:([^"]+)"[^>]*?>/;
    my ($path) =
        $string =~ /<a href=["']?([^ >"']+)["']?>返信/;
    my ($image_url, $thumnail_url) =
        $string =~ m#<a href="([^"]+)" target=(?:_blank|"_blank")><img src=([^ ]+)[^>]+></a>#;

    _to_plain_string $date, $no, $title, $author, $mail;

    return (
        date   => $date,
        no     => $no,
        title  => $title,
        author => $author,
        mail   => $mail,
        path   => $path,
        image_url => $image_url,
        thumbnail_url => $thumnail_url,
    );
}

sub parse_post_string {
    my ($class, $string) = @_;

    my ($meta, $body, $posts) =
        $string =~ m#<input type=checkbox[^>]*>(.+?)<blockquote>(.+?) ?</blockquote>(.+)#s
            or die "Could not parse: $string";

    my %meta = $class->parse_meta_string($meta);

    _to_plain_string $body;

    return WWW::Futaba::Parser::Result::Post->new(
        source => $string,
        body   => $body,
        head   => \%meta,
    );
}

1;
