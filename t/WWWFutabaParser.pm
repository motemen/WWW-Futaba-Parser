package t::WWWFutabaParser;
use strict;
use warnings;
use Path::Class qw(file);
use HTTP::Response;
use HTTP::Request::Common qw(GET);

use Exporter::Lite;

our @EXPORT = qw(fake_http);

sub fake_http ($) {
    my $url = shift;

    (my $path = $url) =~ s<^http://><>;
    $path =~ s</$><>;
    $path =~ s</><->g;
    $path .= '.htm' if $path !~ /\?/ && $path !~ /\.htm$/;
    $path =~ s<\?><__>g;

    my $content = file(__FILE__)->dir->file('samples', $path)->slurp;
    my $res = HTTP::Response->new(200, 'OK', [ Content_Type => 'text/html' ], $content);
    $res->request(GET $url);

    return $res;
}

1;
