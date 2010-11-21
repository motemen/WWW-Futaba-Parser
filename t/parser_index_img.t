use strict;
use warnings;
use utf8;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Index';

my $parser = WWW::Futaba::Parser::Index->new;
isa_ok $parser->web_scraper, 'Web::Scraper';

my $index = $parser->parse(fake_http 'http://img.2chan.net/b/');
isa_ok $index, 'WWW::Futaba::Parser::Result::Index';
isa_ok $index->parser, 'WWW::Futaba::Parser::Index';

my @threads = $index->threads;
is scalar @threads, 10;
isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';
isa_ok $threads[0]->parser, 'WWW::Futaba::Parser::Thread';

is $threads[-1]->body, 'そんな・・・・';
is $threads[-1]->head->{datetime} . '', '2010-02-22T23:20:21';
is $threads[-1]->head->{no},       '81061952';

my @posts = $threads[0]->posts;
is scalar @posts, 10;
isa_ok $posts[0], 'WWW::Futaba::Parser::Result::Post';
isa_ok $posts[0]->parser, 'WWW::Futaba::Parser::Post';

is $posts[-1]->body, '神姫にまで味噌を塗るというのか！？', 'post body';
is $posts[-1]->head->{datetime} . '', '2010-02-22T23:20:32',    'post datetime';
is $posts[-1]->head->{no},       '81061968',               'post no';

is $threads[-1]->uri,           'http://img.2chan.net/b/res/81061952.htm',              'thread uri';
is $threads[-1]->image_uri,     'http://112.78.198.230/img/b/src/1266848421490.jpg',    'thread image';
is $threads[-1]->thumbnail_uri, 'http://112.78.198.230/img/b/thumb/1266848421490s.jpg', 'thread thumbnail';

done_testing;
