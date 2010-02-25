package WWW::Futaba::Parser::Result::Post;
use Any::Moose;
use DateTime;

extends 'WWW::Futaba::Parser::Result';

sub body {
    shift->call_parser('body');
}

sub info {
    shift->call_parser('info');
}

sub mail {
    shift->call_parser('mail');
}

1;
