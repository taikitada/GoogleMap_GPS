package GoogleMapGPS::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'GoogleMapGPS::DB::Row';

table {
    name 'member';
    pk 'id';
    columns qw(id name);
};

table {
    name 'ip_gps';
    pk qw(time, ip);
    columns qw(time, ip, latitude, longitude);

};

1;
