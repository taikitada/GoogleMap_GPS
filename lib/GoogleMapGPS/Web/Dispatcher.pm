package GoogleMapGPS::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;
use Text::CSV;
use GoogleMapGPS::Web::Model::IP_GPS;

any '/' => sub {
    my ($c) = @_;
    my $ip_gps = GoogleMapGPS::Model::IP_GPS->new(db => $c->db);
    my $allip = $ip_gps->all_ip();
    my $params = $c->req->parameters->mixed;
    my @selected_ip = keys $params;
    my @ip_host;
    my @ip_location;
    foreach my $ip (@selected_ip){
       my $gps = $ip_gps->location_data_by_ip($ip);
       foreach my $data (@$gps){
         my $latitude  = $data->{latitude};
         my $longitude  = $data->{longitude};
         push @ip_location, [ $ip_gps->ip_host($ip), $longitude, $latitude];
       }
    }
    foreach my $ip (@$allip){
       push @ip_host, {ip => $ip, host => $ip_gps->ip_host($ip)}
    }
    return $c->render('index.tx', {
    ip_host => \@ip_host, ip_location => \@ip_location
    });
};

post '/post' => sub {
    my ($c) = @_;
    my $params = $c->req->parameters->mixed;
    my $hash = $c->req->uploads;
    my $file_path = $hash->{'upfile'}->{'tempname'};
    open my $fh, '<:raw:eol(LF)', $file_path or Carp::croak "Cannot open file. $!";
    my $parser = Text::CSV->new({binary => 1});
    my @all_data;
    my $ip_gps = GoogleMapGPS::Model::IP_GPS->new(db => $c->db);

    while(my $line = <$fh>){
        $parser->parse($line);
        my @row = $parser->fields();
        print Dumper \@row;
        $ip_gps->insert(\@row);
    }
    close $fh;
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
