use inc::Module::Install;

name 'WWW-Futaba-Parser';
all_from 'lib/WWW/Futaba/Parser.pm';

requires 'Any::Moose';
requires 'Scalar::Util';
requires 'DateTime::Format::Strptime';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'File::Find::Rule';
test_requires 'Path::Class';
test_requires 'HTTP::Response';
test_requires 'HTTP::Request::Common';

readme_markdown_from_pod;

auto_include;

WriteAll;
