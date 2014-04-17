package GoogleMapGPS::Model::IP_GPS;
use strict;
use warnings;
use Mouse;
use Data::Dumper;
use Socket;

has 'db' => ( is => 'ro', isa => 'Teng', required => 1 );

__PACKAGE__->meta->make_immutable();

use constant QUERY => {
  SELECT_DISTINCT_IP =>
  "select distinct ip from ip_gps",
  SELECT_LOCATION_DATA_BY_IP =>
  "select latitude, longitude from ip_gps where ip = ?",
};

sub all_ip {
  my $self = shift;
  my $itr = $self->db->search_by_sql(
    QUERY->{'SELECT_DISTINCT_IP'}
  );
  my $ip = [];

  while ( my $row = $itr->next){
    push @$ip, $row->ip;
  }
  return $ip;
};

sub location_data_by_ip {
  my $self = shift;
  my $ip = shift;
  my $itr = $self->db->search('ip_gps', +{ip => $ip});
  my @location_data;
  while ( my $row = $itr->next){
    push @location_data, {longitude => $row->longitude, latitude => $row->latitude};
  }
  return \@location_data;
};

sub insert {
  my $self = shift;
  my $ip_gps = shift;

  eval{
      $self->db->fast_insert('ip_gps', +{ time => @$ip_gps->[0], ip => @$ip_gps->[1], latitude => @$ip_gps->[2], longitude => @$ip_gps->[3]});
  };
  if( $@ ){
      print "catch!! $@\n";
  }
};

sub ip_host {
  my $self = shift;
  my $ip = shift;
  my $ip_addr = inet_aton($ip);
  my $name  = gethostbyaddr($ip_addr, AF_INET);
  return $name;
};

1;
