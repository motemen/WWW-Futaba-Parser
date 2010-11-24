use strict;
use warnings;
use Test::More;
use File::Find::Rule;

my @files = File::Find::Rule->file->name('*.pm')->in('lib');

plan tests => scalar @files;

foreach (@files) {
    s/\.pm$//;
    s#^lib/##;
    s</><::>g;
    use_ok $_;
}
