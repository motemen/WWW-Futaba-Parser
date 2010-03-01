use strict;
use warnings;
use Curses::UI;

use lib 'lib';
use WWW::Futaba::Parser;

our $uri = shift or usage();

my $cui = Curses::UI->new(-color_support => 1);
$cui->set_binding(sub { exit 0 }, 'q');

my $w = $cui->add('window', 'Window');

sub update {
    $cui->status("fetching $uri...");

    my $res = WWW::Futaba::Parser->parse($uri);

    if ($res->isa('WWW::Futaba::Parser::Result::Index')) {
        my @threads = $res->threads;
        my $format = sub {
            my $t = shift;
            '[' . $t->head->{no} . '] ' . [split /\n/, $t->body]->[0];
        };
        my $list = $w->getobj('threads') || $w->add(
            'threads', 'Listbox',
            -onchange => sub {
                local $uri = shift->get;
                update();
            }
        );
        $list->values([ map { $_->uri } @threads ]);
        $list->labels({ map { $_->uri => $format->($_) } @threads });
        $list->set_binding(sub { goto \&update }, 'r');
    }
    elsif ($res->isa('WWW::Futaba::Parser::Result::Thread')) {
        my $format = sub {
            my $p = shift;
            $p->head->{datetime} . "\n" . $p->body;
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
