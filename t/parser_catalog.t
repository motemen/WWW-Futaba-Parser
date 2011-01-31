use strict;
use warnings;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Catalog';

subtest img => sub {
    my $index = WWW::Futaba::Parser::Catalog->parse(fake_http 'http://img.2chan.net/b/futaba.php?mode=cat');
    isa_ok $index, 'WWW::Futaba::Parser::Result::Catalog';

    my @threads = $index->threads;
    is scalar @threads, 75;

    isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';
    ok !defined $threads[0]->image_url;
    is $threads[0]->url, 'http://img.2chan.net/b/res/107097815.htm';
    is $threads[0]->thumbnail_url, 'http://apr.2chan.net/img/b/thumb/1296447465957s.jpg';
};

subtest jun => sub {
    my $index = WWW::Futaba::Parser::Catalog->parse(fake_http 'http://jun.2chan.net/b/futaba.php?mode=cat');
    isa_ok $index, 'WWW::Futaba::Parser::Result::Catalog';

    my @threads = $index->threads;
    is scalar @threads, 49;

    isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';
    ok !defined $threads[0]->image_url;
    is $threads[0]->url, 'http://jun.2chan.net/b/res/15330189.htm';
};

done_testing;
