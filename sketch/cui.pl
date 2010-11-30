use strict;
use warnings;
use Curses::UI;
use LWP::Simple qw($ua);

use lib 'lib';
use WWW::Futaba::Parser;

our $url = shift or usage();

my $cui = Curses::UI->new(-color_support => 1);
$cui->set_binding(sub { exit 0 }, 'q');

my $w = $cui->add('window', 'Window');

sub update {
    $cui->status("fetching $url...");

    my $res = WWW::Futaba::Parser->parser_for_url($url)->parse($ua->get($url));

    if ($res->isa('WWW::Futaba::Parser::Result::Index')) {
        my @threads = $res->threads;
        my $format = sub {
            my $t = shift;
            '[' . $t->head->{no} . '] ' . [ split /\n/, $t->body ]->[0] . ' <' . $t->head->{path} . '>';
        };
        my $list = $w->getobj('threads') || $w->add(
            'threads', 'Listbox',
            -onchange => sub {
                local $url = shift->get;
                update();
            }
        );
        $list->values([ map { $_->url } @threads ]);
        $list->labels({ map { $_->url => $format->($_) } @threads });
        $list->set_binding(sub { goto \&update }, 'r');
    }
    elsif ($res->isa('WWW::Futaba::Parser::Result::Thread')) {
        my $format = sub {
            my $p = shift;
            $p->datetime . "\n" . $p->body;
        };
        my $text = $w->getobj('thread_text') || $w->add(
            'thread_text', 'TextViewer',
            -y      => 5,
            -border => 1,
        );
        $text->text(join "\n---\n", map { $format->($_) } $res, $res->posts);
        $text->set_binding(sub {
            $text->lose_focus;
            $w->delete('thread_text');
            $w->draw;
        }, 'q');
        $text->set_binding(sub {
            $text->lose_focus;
            $w->delete('thread_text');
            goto \&update;
        }, 'r');
        $text->modalfocus;
    }
}

update;

$cui->mainloop;
