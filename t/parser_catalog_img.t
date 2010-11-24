use strict;
use warnings;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser::Catalog';

my $parser = WWW::Futaba::Parser::Catalog->new;
isa_ok $parser->web_scraper, 'Web::Scraper';

my $index = $parser->parse(fake_http 'http://img.2chan.net/b/futaba.php?mode=cat');
isa_ok $index, 'WWW::Futaba::Parser::Result::Catalog';
isa_ok $index->parser, 'WWW::Futaba::Parser::Catalog';

my @threads = $index->threads;
is scalar @threads, 75;

local $TODO = 'todo';

isa_ok $threads[0], 'WWW::Futaba::Parser::Result::Thread';

done_testing;
