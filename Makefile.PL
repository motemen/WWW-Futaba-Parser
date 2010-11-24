use inc::Module::Install;

name 'WWW-Futaba-Parser';
all_from 'lib/WWW/Futaba/Parser.pm';

requires 'Any::Moose';
requires 'Scalar::Util';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
build_requires 'File::Find::Rule';
build_requires 'Path::Class';
build_requires 'HTTP::Response';
build_requires 'HTTP::Request::Common';

readme_markdown_from_pod;

auto_include;

WriteAll;
