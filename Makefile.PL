use inc::Module::Install;

name 'WWW-Futaba-Parser';
all_from 'lib/WWW/Futaba/Parser.pm';

requires 'Any::Moose';
requires 'Web::Scraper';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_include;

WriteAll;
