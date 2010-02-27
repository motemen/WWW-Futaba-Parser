use strict;
use warnings;
use utf8;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Index';

my $parser = WWW::Futaba::Parser::Index->new;

my $index = $parser->parse(fake_http 'http://jun.2chan.net/b/futaba.htm');
isa_ok $index, 'WWW::Futaba::Parser::Result::Index';
isa_ok $index->parser, 'WWW::Futaba::Parser::Index';

my @threads = $index->threads;
is scalar @threads, 10;
isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';
isa_ok $threads[0]->parser, 'WWW::Futaba::Parser::Thread';

is $threads[-1]->body . "\n", <<__BODY__;
金曜恒例音ゲーちょもるめらん
ロケテ開催中
__BODY__

is $threads[-1]->head->{title},  '無念';
is $threads[-1]->head->{author}, 'としあき';

my @posts = $threads[-1]->posts;
is scalar @posts, 5;

is $posts[-1]->body . "\n", <<__BODY__;
>ここまでうたっちの話題なし
収録曲に残酷な天使のテーゼがあったので
エヴァミミ登場とワクテカしてたけど
そうでもなかったぜ！
__BODY__
is $posts[-1]->image_uri,     'http://apr.2chan.net/jun/b/src/1267192182797.jpg';
is $posts[-1]->thumbnail_uri, 'http://apr.2chan.net/jun/b/thumb/1267192182797s.jpg';

done_testing;
