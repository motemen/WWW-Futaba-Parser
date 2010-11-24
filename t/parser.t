use strict;
use warnings;
use Test::More;
use t::WWWFutabaParser;

use_ok 'WWW::Futaba::Parser';

{
    ok my $res = WWW::Futaba::Parser->parser_for_url('http://img.2chan.net/b/')->parse(fake_http 'http://img.2chan.net/b/');
    isa_ok $res, 'WWW::Futaba::Parser::Result::Index';
}

{
    ok my $res = WWW::Futaba::Parser->parser_for_url('http://img.2chan.net/b/res/81259855.htm')->parse(fake_http 'http://img.2chan.net/b/res/81259855.htm');
    isa_ok $res, 'WWW::Futaba::Parser::Result::Thread';
}

done_testing;
