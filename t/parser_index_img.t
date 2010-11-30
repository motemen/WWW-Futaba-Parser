use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep qw(cmp_deeply ignore isa str);
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Index';

isa_ok
    my $index = WWW::Futaba::Parser::Index->parse(fake_http 'http://img.2chan.net/b/'),
    'WWW::Futaba::Parser::Result::Index',
    '$index';

my @threads = $index->threads;
is scalar @threads, 10;

subtest 'first thread' => sub {
    my $thread = $threads[0];
    is $thread->body, "あと少しで来るよ\n当日出張だけどな\nクソァ！", '$thread->body';
    # TODO レス64件省略
    cmp_deeply $thread->datetime, isa('DateTime') & str('2010-02-22T22:42:20'), '$thread->datetime';
    cmp_deeply $thread->url, isa('URI') & str('http://img.2chan.net/b/res/81058118.htm'), '$thread->url';
    cmp_deeply $thread->head, {
        no     => '81058118',
        author => undef,
        date   => ignore,
        mail   => undef,
        path   => 'res/81058118.htm',
        title  => undef,
        image_url => 'http://feb.2chan.net/img/b/src/1266846140104.jpg',
        thumbnail_url => 'http://feb.2chan.net/img/b/thumb/1266846140104s.jpg',
    }, '$thread->head';

    cmp_deeply $thread->image_url,     isa('URI') && str('http://feb.2chan.net/img/b/src/1266846140104.jpg'),    'thread image';
    cmp_deeply $thread->thumbnail_url, isa('URI') && str('http://feb.2chan.net/img/b/thumb/1266846140104s.jpg'), 'thread thumbnail';

    unless (Test::More->builder->is_passing) {
        $thread->clear_datetime;
        diag explain $thread;
    }
};

subtest 'last thread' => sub {
    my $thread = $threads[-1];
    isa_ok $thread, 'WWW::Futaba::Parser::Result::Thread', '$thread';
    is $thread->body, 'そんな・・・・', '$thread->body';
    cmp_deeply $thread->datetime, isa('DateTime') & str('2010-02-22T23:20:21'), '$thread->datetime';
    cmp_deeply $thread->url, isa('URI') & str('http://img.2chan.net/b/res/81061952.htm'), '$thread->url';
    cmp_deeply $thread->head, {
        no     => '81061952',
        author => undef,
        date   => ignore,
        mail   => undef,
        path   => 'res/81061952.htm',
        title  => undef,
        image_url => 'http://112.78.198.230/img/b/src/1266848421490.jpg',
        thumbnail_url => 'http://112.78.198.230/img/b/thumb/1266848421490s.jpg',
    }, '$thread->head';

    cmp_deeply $thread->image_url,     isa('URI') && str('http://112.78.198.230/img/b/src/1266848421490.jpg'),    'thread image';
    cmp_deeply $thread->thumbnail_url, isa('URI') && str('http://112.78.198.230/img/b/thumb/1266848421490s.jpg'), 'thread thumbnail';

    unless (Test::More->builder->is_passing) {
        $thread->clear_datetime;
        diag explain $thread;
    }
};

my @posts = $threads[0]->posts;
is scalar @posts, 10;

my $post = $posts[-1];
subtest post => sub {
    isa_ok $post, 'WWW::Futaba::Parser::Result::Post', '$post';
    is $post->body, '神姫にまで味噌を塗るというのか！？', '$post->body';
    cmp_deeply $post->datetime, isa('DateTime') & str('2010-02-22T23:20:32'), '$post->datetime';
    cmp_deeply $post->head, {
        no     => '81061968',
        author => undef,
        date   => ignore,
        mail   => undef,
        path   => undef,
        title  => undef,
        image_url => undef,
        thumbnail_url => undef,
    }, '$post->head';

    unless (Test::More->builder->is_passing) {
        $post->clear_datetime;
        diag explain $post;
    }
};

done_testing;
