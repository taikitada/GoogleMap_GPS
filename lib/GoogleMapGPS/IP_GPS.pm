package GoogleMapGPS::Model::IP_GPS;
use strict;
use warnings;
use Mouse;
use Data::Dumper;

has 'db' => ( is => 'ro', isa => 'Teng', required => 1 );

__PACKAGE__->meta->make_immutable();




1;
