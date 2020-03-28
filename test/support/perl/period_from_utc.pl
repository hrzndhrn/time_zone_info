#!/usr/local/bin/perl

use DateTime;
use DateTime::TimeZone;
use DateTime::Format::ISO8601;
use DateTime::Format::Strptime;

my $format = DateTime::Format::Strptime->new( pattern => '%FT%T');
my $dt = $format->parse_datetime( $ARGV[1] );

my $tz = DateTime::TimeZone->new(name => $ARGV[0]);

my $dst = $tz->is_dst_for_datetime( $dt ) ? 'true' : 'false';
my $abbr = $tz->short_name_for_datetime( $dt );
my $offset = $tz->offset_for_datetime($dt);

print(qq|{:ok, %{offset: $offset, zone_abbr: "$abbr", dst: $dst}}|);
