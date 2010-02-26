use strict;
use warnings;
use utf8;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Thread';

my $parser = WWW::Futaba::Parser::Thread->new;
isa_ok $parser->web_scraper, 'Web::Scraper';

my $thread = $parser->parse(fake_http 'http://img.2chan.net/b/res/81259855.htm');
isa_ok $thread, 'WWW::Futaba::Parser::Result::Thread';
isa_ok $thread->parser, 'WWW::Futaba::Parser::Thread';

ok $thread->call_parser('body_node'), 'body_node';

is $thread->body, 'RPGの銃使いは微妙な奴が多い';
is $thread->head->{datetime}, '2010-02-25T20:42:40';
is $thread->head->{no},       '81259855';

my @posts = $thread->posts;
is scalar @posts, 33;
isa_ok $posts[0], 'WWW::Futaba::Parser::Result::Post';
isa_ok $posts[0]->parser, 'WWW::Futaba::Parser::Post';

is $posts[26]->body, ">強いのならワイルドアームズに沢山居るぞ！\nｽｯ", 'post body';
is $posts[26]->head->{datetime}, '2010-02-25T21:00:17',               'post datetime';
is $posts[26]->head->{no},       '81261312',                          'post no';
is $posts[26]->call_parser('mail'),     'ファイネストアーツ　ラクウェル';

done_testing;
