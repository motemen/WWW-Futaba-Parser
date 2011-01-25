use strict;
use utf8;
use Test::Base;
use Test::Deep;
use t::WWWFutabaParser;
use WWW::Futaba::Parser;

sub parse_url {
    my $url = shift;
    return WWW::Futaba::Parser->parser_for_url($url)->parse(fake_http $url);
}

sub as_list_length {
    my $hash = shift;
    my $len = filter_arguments;
    $_ = [ map { $hash->{$_} ? noclass(superhashof($hash->{$_})) : ignore } (0 .. $len - 1) ]
}

plan tests => 2 * blocks;

run {
    my $block = shift;
    my $url = $block->url;
    chomp $url;
    my $parsed = parse_url($url);
    cmp_deeply $parsed, noclass(superhashof $block->attr), $url;
    cmp_deeply [ $parsed->posts ], $block->posts, "$url (posts)" if $block->posts;
    use Test::More;
    diag explain $parsed->posts->[1];
};

__END__

=== dat
--- url
http://dat.2chan.net/b/res/62973238.htm
--- attr yaml
body: "♪あなたの街にある埼玉りそな銀行\n9時です"
--- posts yaml as_list_length=52
0:
  body: うむ

=== jun
--- url
http://jun.2chan.net/b/res/15299641.htm
--- attr yaml
body: 画像会話スレ
head:
  title: 無念
  author: としあき
  mail: ~
  no: 15299641
  date: 11/01/25(火)20:21:11
  thumbnail_url: http://jan.2chan.net/jun/b/thumb/1295954471132s.jpg
  image_url: http://jan.2chan.net/jun/b/src/1295954471132.jpg
  path: ~
--- posts yaml as_list_length=70
0:
  body: ひー坊キター
  head:
    title: 無念
    author: としあき
    mail: ~
    no: 15299645
    image_url: ~
    thumbnail_url: ~
    date: 11/01/25(火)20:21:44
    path: ~
1:
  body: ｷﾀ━━━(ﾟ∀ﾟ)━━━!!
  head:
    title: 無念
    author: としあき
    mail: ~
    no: 15299649
    image_url: http://sep.2chan.net/jun/b/src/1295954533771.jpg
    thumbnail_url: http://sep.2chan.net/jun/b/thumb/1295954533771s.jpg
    date: 11/01/25(火)20:22:13
    path: ~
