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
    my $url = $block->name;
    my $parsed = parse_url($url);
    cmp_deeply $parsed, noclass(superhashof $block->attr), $url;
    cmp_deeply [ $parsed->posts ], $block->posts, "$url (posts)" if $block->posts;
};

__END__

=== http://dat.2chan.net/b/res/62973238.htm
--- attr yaml
body: "♪あなたの街にある埼玉りそな銀行\n9時です"
head:
  title: ~
  author: ~
  mail: りそな
  no: 62973238
  date: 11/01/24(月)09:00:00
  thumbnail_url: http://jul.2chan.net/dat/b/thumb/1295827200356s.jpg
  image_url: http://jul.2chan.net/dat/b/src/1295827200356.gif
  path: ~
--- posts yaml as_list_length=52
0:
  body: うむ
  head:
    title: ~
    author: ~
    mail: ~
    no: 62973274
    date: 11/01/24(月)09:28:05
    thumbnail_url: ~
    image_url: ~
    path: ~
2:
  body: "♪あなたの街にある埼玉りそな銀行\n10時です"
  head:
    title: ~
    author: ~
    mail: りそな
    no: 62973328
    date: 11/01/24(月)10:00:00
    thumbnail_url: ~
    image_url: ~
    path: ~

=== http://jun.2chan.net/b/res/15299641.htm
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

=== http://jun.2chan.net/b/res/15306056.htm
--- attr yaml
body: |-
 スレのルール
 ・100レスまではsage進行
 ・依頼の際は具体的に何をどうして欲しいかはっきり説明
 　職人におまかせみたいな依頼はだめ
 ・依頼をスルーされても泣かない
 ・督促厳禁
 ・職人の少ない時はなるべく依頼を控えるように
 ・再依頼OK、一度作ってもらったものでもOK
 ・依頼できるのは1スレで1回のみ
 ・複数の依頼、よそとのマルチは厳禁
 ・依頼あき、職人あき共に落ちる際はスレで報告
 ・赤字が出たら依頼はNG
 
 ID表示スレ立て暫定導入
head:
  author: としあき
  mail: id表示
  title: 無念
  no: 15306056
  image_url: http://jan.2chan.net/jun/b/src/1296057602991.jpg
  thumbnail_url: http://jan.2chan.net/jun/b/thumb/1296057602991s.jpg
  date: 11/01/27(木)01:00:02
  path: ~

--- posts yaml as_list_length=146
10:
  body: |-
   スレ立ておつです

   右上の文字を消してください
   よろしくお願いします
  head:
    author: としあき
    mail: sage
    title: 無念
    no: 15306220
    image_url: http://aug.2chan.net/jun/b/src/1296059265938.jpg
    thumbnail_url: http://aug.2chan.net/jun/b/thumb/1296059265938s.jpg
    date: 11/01/27(木)01:27:45
    path: ~

=== http://may.2chan.net/b/res/34693953.htm
--- attr yaml
body: ＩＳスレ
head:
  author: としあき
  date: 11/02/05(土)21:19:03
  mail: ~
  no: 34693953
  path: ~
  title: 無念
  thumbnail_url: http://feb.2chan.net/may/b/thumb/1296908343395s.jpg
  image_url: http://feb.2chan.net/may/b/src/1296908343395.jpg
--- posts yaml as_list_length=110
107:
  body: 渋いおばさんキャラでもいいぞ
  head:
    thumbnail_url: http://aug.2chan.net/may/b/thumb/1296909639219s.jpg
    image_url: http://aug.2chan.net/may/b/src/1296909639219.jpg
    author: としあき
    date: 11/02/05(土)21:40:39
    mail: ~
    no: 34699313
    path: ~
    title: 無念
109:
  body: |-
   >全員で大合唱とか
   出席番号１番さん埋めろやコラ
  head:
    thumbnail_url: ~
    image_url: ~
    author: としあき
    date: 11/02/05(土)21:40:48
    mail: ~
    no: 34699338 
    path: ~
    title: 無念
