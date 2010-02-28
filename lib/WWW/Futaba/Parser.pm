package WWW::Futaba::Parser;
use strict;
use warnings;
use UNIVERSAL::isa;
use UNIVERSAL::require;
use URI;

our @Parsers = (
    qw<^/\w+/res/\d+\.htm> => 'Thread',
    qw<^/\w+/futaba\.php>  => 'Catalog',
    qw<^/\w+/>             => 'Index',
);

sub parse {
    my ($class, $target) = @_;

    my $uri;
    if (UNIVERSAL::isa($target, 'HTTP::Response')) {
        $uri = $target->base;
    } elsif (UNIVERSAL::isa($target, 'URI')) {
        $uri = $target;
    } else {
        $uri = URI->new($target);
    }

    my $path = $uri->path;
    my @parsers = @Parsers;
    while (my ($regexp, $kind) = splice @parsers, 0, 2) {
        if ($path =~ $regexp) {
            my $parser_class = __PACKAGE__ . '::' . $kind;
            $parser_class->require or die $@;
            my $parser = $parser_class->new;
            return $parser->parse($target);
        }
    }

    die "Could not parse $target";
}

1;

__END__

=head1 NAME

WWW::Futaba::Parser -

=head1 SYNOPSIS

  use WWW::Futaba::Parser;

=head1 DESCRIPTION

WWW::Futaba::Parser is

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
