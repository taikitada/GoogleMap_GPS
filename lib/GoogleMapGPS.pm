package GoogleMapGPS;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.008001;
use GoogleMapGPS::DB::Schema;
use GoogleMapGPS::DB;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();

__PACKAGE__->load_plugin(qw/DBI/);
# initialize database
use DBI;
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh();
    my $driver_name = $dbh->{Driver}->{Name};
    my $fname = lc("sql/${driver_name}.sql");
    open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
    my $source = do { local $/; <$fh> };
    for my $stmt (split /;/, $source) {
        next unless $stmt =~ /\S/;
        $dbh->do($stmt) or die $dbh->errstr();
    }
}

use Teng;
use Teng::Schema::Loader;
my $schema;
sub db {
    my $c = shift;
    if (!exists $c->{db}) {
        my $conf = $c->config->{DBI}
            or die "Missing configuration about DBI";
        my $dbh = DBI->connect(@{$conf});
        if ( !defined $schema ) {
            $c->{db} = Teng::Schema::Loader->load(
                namespace => 'GoogleMapGPS::DB',
                dbh       => $dbh,
            );
            $schema = $c->{db}->schema;
        } else {
            $c->{db} = GoogleMapGPS::DB->new(
                schema       => $schema,
                dbh          => $dbh,
                # I suggest to enable following lines if you are using mysql.
                # on_connect_do => [
                #     'SET SESSION sql_mode=STRICT_TRANS_TABLES;',
                # ],
            );
        }
    }
    return $c->{db};
}

1;__END__

=head1 NAME

GoogleMapGPS - GoogleMapGPS

=head1 DESCRIPTION

This is a main context class for GoogleMapGPS

=head1 AUTHOR

GoogleMapGPS authors.
