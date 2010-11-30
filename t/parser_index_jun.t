use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep qw(cmp_deeply ignore isa str);
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Index';

isa_ok
    my $index = WWW::Futaba::Parser::Index->parse(fake_http 'http://jun.2chan.net/b/futaba.htm'),
    'WWW::Futaba::Parser::Result::Index',
    '$index';

my @threads = $index->threads;
is scalar @threads, 10;

my $thread = $threads[-1];
subtest thread => sub {
    isa_ok $thread, 'WWW::Futaba::Parser::Result::Thread', '$thread';
    is $thread->body, "金曜恒例音ゲーちょもるめらん\nロケテ開催中", '$thread->body';
    cmp_deeply $thread->datetime, isa('DateTime') & str('2010-02-26T21:05:32'), '$thread->datetime';
    cmp_deeply $thread->url, isa('URI') & str('http://jun.2chan.net/b/res/13037787.htm'), '$thread->url';
    cmp_deeply $thread->head, {
        no     => '13037787',
        author => 'としあき',
        date   => ignore,
        mail   => undef,
        path   => 'res/13037787.htm',
        title  => '無念',
        image_url => 'http://112.78.201.90/jun/b/src/1267185932919.gif',
        thumbnail_url => 'http://112.78.201.90/jun/b/thumb/1267185932919s.jpg',
    }, '$thread->head';

    unless (Test::More->builder->is_passing) {
        $thread->clear_datetime;
        diag explain $thread;
    }
};

my @posts = $threads[-1]->posts;
is scalar @posts, 5;

my $post = $posts[-1];
subtest post => sub {
    isa_ok $post, 'WWW::Futaba::Parser::Result::Post', '$post';
    is $post->body, ">ここまでうたっちの話題なし\n収録曲に残酷な天使のテーゼがあったので\nエヴァミミ登場とワクテカしてたけど\nそうでもなかったぜ！", '$post->body';
    cmp_deeply $post->datetime, isa('DateTime') & str('2010-02-26T22:49:42'), '$post->datetime';
    cmp_deeply $post->head, {
        no => '13039303',
        author => 'としあき',
        date   => ignore,
        mail   => undef,
        path   => undef,
        title  => '無念',
        image_url => 'http://apr.2chan.net/jun/b/src/1267192182797.jpg',
        thumbnail_url => 'http://apr.2chan.net/jun/b/thumb/1267192182797s.jpg',
    };

    unless (Test::More->builder->is_passing) {
        $post->clear_datetime;
        diag explain $post;
    }
};

done_testing;
