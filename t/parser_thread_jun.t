use strict;
use warnings;
use utf8;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Thread';

my $parser = WWW::Futaba::Parser::Thread->new;

my $thread = $parser->parse(fake_http 'http://jun.2chan.net/b/res/13042338.htm');
isa_ok $thread, 'WWW::Futaba::Parser::Result::Thread';
isa_ok $thread->parser, 'WWW::Futaba::Parser::Thread';

ok $thread->call_parser('body_node'), 'body_node';

is $thread->body, "そろそろマジレスフォルダ\n捨てようと思うんだけど、\nもったいないかな？どう？", 'thread body';
is $thread->head->{datetime}, '2010-02-27T08:22:14', 'thread datetime';
is $thread->head->{no},       '13042338',            'thread no';
is $thread->head->{title},    '無念',                'thread title';
is $thread->head->{author},   'としあき',            'thread author';

my @posts = $thread->posts;
is scalar @posts, 13;
isa_ok $posts[0], 'WWW::Futaba::Parser::Result::Post';
isa_ok $posts[0]->parser, 'WWW::Futaba::Parser::Post';

is $posts[0]->body, 'ストレージにうｐ汁';
is $posts[0]->head->{title}, '無念';
is $posts[0]->head->{author}, 'としあき';
is $posts[0]->head->{datetime}, '2010-02-27T08:26:00';
is $posts[0]->head->{no}, '13042346';
ok !$posts[0]->image_uri;
ok !$posts[0]->thumbnail_uri;

is $posts[1]->body, "俺はアインフォルダ\nどうしようか\n迷ってる・・・。";
is $posts[1]->head->{title}, '無念';
is $posts[1]->head->{author}, 'としあき';
is $posts[1]->head->{datetime}, '2010-02-27T08:30:13';
is $posts[1]->head->{no}, '13042356';
is $posts[1]->image_uri, 'http://feb.2chan.net/jun/b/src/1267227013425.jpg';
is $posts[1]->thumbnail_uri, 'http://feb.2chan.net/jun/b/thumb/1267227013425s.jpg';

done_testing;
