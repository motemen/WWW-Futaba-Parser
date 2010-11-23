use strict;
use warnings;
use utf8;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Thread';

my $thread = WWW::Futaba::Parser::Thread->parse(fake_http 'http://img.2chan.net/b/res/81259855.htm');
isa_ok $thread, 'WWW::Futaba::Parser::Result::Thread';

is $thread->body, 'RPGの銃使いは微妙な奴が多い';
is $thread->datetime . '', '2010-02-25T20:42:40';
is $thread->head->{no},    '81259855';

my @posts = $thread->posts;
is scalar @posts, 33;
isa_ok $posts[0], 'WWW::Futaba::Parser::Result::Post';

is $posts[26]->body, ">強いのならワイルドアームズに沢山居るぞ！\nｽｯ", 'post body';
is $posts[26]->datetime . '', '2010-02-25T21:00:17',                  'post datetime';
is $posts[26]->head->{no}, '81261312',                                'post no';
is $posts[26]->head->{mail}, 'ファイネストアーツ　ラクウェル',        'post mail';

done_testing;
