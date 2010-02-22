use strict;
use warnings;
use utf8;
use Test::More;
use Path::Class qw(file);
use HTTP::Response;
use HTTP::Request::Common qw(GET);

sub fake_http ($) {
    my $url = shift;

    (my $path = $url) =~ s<^http://><>;
    $path =~ s</$><>;
    $path =~ s</><->g;

    my $content = file(__FILE__)->dir->file('samples', "$path.htm")->slurp;
    my $res = HTTP::Response->new(200, 'OK', [ Content_Type => 'text/html' ], $content);
    $res->request(GET $url);

    return $res;
}

use_ok 'WWW::Futaba::Parser';

my $parser = WWW::Futaba::Parser->new;

my $index = $parser->parse_index(fake_http 'http://img.2chan.net/b/');
isa_ok $index, 'WWW::Futaba::Parser::Result::Index';

my @threads = $index->threads;
is scalar @threads, 10;
isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';

is $threads[-1]->body, 'そんな・・・・';
is $threads[-1]->meta->{datetime}, '2010-02-22T23:20:21';
is $threads[-1]->meta->{no},       '81061952';

my @posts = $threads[0]->posts;
is scalar @posts, 10;
isa_ok $posts[0], 'WWW::Futaba::Parser::Result::Post';

is $posts[-1]->body, '神姫にまで味噌を塗るというのか！？', 'post body';
is $posts[-1]->meta->{datetime}, '2010-02-22T23:20:32',    'post datetime';
is $posts[-1]->meta->{no},       '81061968',               'post no';

is $threads[-1]->uri,           'http://img.2chan.net/b/res/81061952.htm',              'thread uri';
is $threads[-1]->image_uri,     'http://112.78.198.230/img/b/src/1266848421490.jpg',    'thread image';
is $threads[-1]->thumbnail_uri, 'http://112.78.198.230/img/b/thumb/1266848421490s.jpg', 'thread thumbnail';

done_testing;
