use strict;
use warnings;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Catalog';

TODO: {
todo_skip 'not implemented', 3;

my $index = WWW::Futaba::Parser::Catalog->parse(fake_http 'http://img.2chan.net/b/futaba.php?mode=cat');
isa_ok $index, 'WWW::Futaba::Parser::Result::Catalog';

my @threads = $index->threads;
is scalar @threads, 75;

isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';

}

done_testing;
