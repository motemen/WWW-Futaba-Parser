use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep qw(cmp_deeply);
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Thread';

my $thread = WWW::Futaba::Parser::Thread->parse(fake_http 'http://dat.2chan.net/b/res/62973238.htm');

cmp_deeply $thread, do {
    package Test::Deep;
    isa('WWW::Futaba::Parser::Result::Thread')
        & methods(
            body          => "♪あなたの街にある埼玉りそな銀行\n9時です",
            thumbnail_url => isa('URI') & str('http://jul.2chan.net/dat/b/thumb/1295827200356s.jpg'),
            image_url     => isa('URI') & str('http://jul.2chan.net/dat/b/src/1295827200356.gif'),
            datetime      => isa('DateTime') & str('2011-01-24T09:00:00'),
            head          => superhashof({ no => '62973238', mail => 'りそな' }),
        );
};

is scalar @{$thread->posts}, 52;

my $post = $thread->posts->[33];
cmp_deeply $post, do {
    package Test::Deep;
    isa('WWW::Futaba::Parser::Result::Post')
        & methods(
            body => "♪あなたの街にある埼玉りそな銀行\n5時です",
            head => superhashof({ no => '62974821', mail => 'りそな' })
        );
};

done_testing;
