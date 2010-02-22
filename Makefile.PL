use inc::Module::Install;
name 'WWW-Futaba-Parser';
all_from 'lib/WWW/Futaba/Parser.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
