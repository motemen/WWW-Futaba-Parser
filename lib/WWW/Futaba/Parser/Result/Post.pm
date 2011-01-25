package WWW::Futaba::Parser::Result::Post;
use Any::Moose;

has body => (
    is  => 'rw',
    isa => 'Str',
);

has head => (
    is  => 'rw',
    isa => 'HashRef',
);

has datetime => (
    is  => 'rw',
    isa => 'Maybe[DateTime]',
    lazy_build => 1,
);

sub _build_datetime {
    my $self = shift;

    my $string = $self->head->{date} or return undef;
    my ($d, $t) = $string =~ m#(\d\d/\d\d/\d\d).*?(\d\d:\d\d:\d\d)# or do {
        warn "Could not parse date: $string";
        return undef;
    };

    require DateTime::Format::Strptime;
    return  DateTime::Format::Strptime::strptime(
        '%y/%m/%d %H:%M:%S', "$d $t"
    );
}

has image_url => (
    is  => 'rw',
    isa => 'Maybe[URI]',
    default => sub {
        my $url = $_[0]->head->{image_url} or return undef;
        URI->new($url);
    },
);

has thumbnail_url => (
    is  => 'rw',
    isa => 'Maybe[URI]',
    default => sub {
        my $url = $_[0]->head->{thumbnail_url} or return undef;
        URI->new($url);
    },
);

has source => (
    is  => 'ro',
    isa => 'Str',
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;
