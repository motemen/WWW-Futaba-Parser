use strict;
use warnings;
use lib 'lib';
use WWW::Futaba::Parser;
use LWP::Simple qw($ua);
use Perl6::Say;
use YAML;

sub yaml { say +YAML::Dump @_ }

my $parser = WWW::Futaba::Parser->new;
my $res = $parser->parse_index($ua->get('http://img.2chan.net/b/'));

foreach my $thread ($res->threads) {
    say '======';
    say $thread->uri;
    yaml $thread->meta;
    foreach my $post ($thread->posts) {
        # say $post->image;
        # say $post->author;
        yaml $post->meta;
        say $post->body;
    };
}
