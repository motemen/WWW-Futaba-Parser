package WWW::Futaba::Parser::Result::Thread;
use Any::Moose;
use URI;

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

has url => (
    is  => 'rw',
    isa => 'Maybe[URI]',
    lazy_build => 1,
);

sub _build_url {
    my $self = shift;
    my $path = $self->head->{path} or return undef;
    return URI->new_abs($path, $self->base);
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
        my $url = $_[0]->head->{thumbnail_url} || do {
            # XXX
            my $url = $_[0]->head->{catalog_thumbnail_url};
            $url =~ s(/cat/)(/thumb/) if $url;
            $url;
        } or return undef;
        URI->new($url);
    },
);

has catalog_thumbnail_url => (
    is  => 'rw',
    isa => 'Maybe[URI]',
    default => sub {
        my $url = $_[0]->head->{catalog_thumbnail_url} or return undef;
        URI->new($url);
    },
);

has base => (
    is  => 'rw',
    isa => 'URI',
    default => sub { URI->new('http:') },
);

has posts => (
    is  => 'rw',
    isa => 'ArrayRef[WWW::Futaba::Parser::Result::Post]',
    auto_deref => 1,
);

__PACKAGE__->meta->make_immutable;

1;
