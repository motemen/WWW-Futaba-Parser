package WWW::Futaba::Parser::Result::Post;
use Any::Moose;
use DateTime;

extends 'WWW::Futaba::Parser::Result';

sub mail {
    shift->call_parser('mail');
}

1;
