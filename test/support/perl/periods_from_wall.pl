#!/usr/local/bin/perl

use strict;
use DateTime;
use DateTime::TimeZone;
use DateTime::Format::ISO8601;
use DateTime::Format::Strptime;

my $format = DateTime::Format::Strptime->new(pattern => '%FT%T');
my $dt = $format->parse_datetime($ARGV[1]);
my $time_zone = $ARGV[0];

info("$dt at $time_zone");

eval {
  $dt->set_time_zone($time_zone);

  info("valid date");

  my $od = $dt->clone;
  my $pd = $dt->clone;

  $pd->add(days => -1);
  $od->add(seconds => $dt->offset - $pd->offset);

  if ($dt->offset - $od->offset == 0) {
    printf(qq|{:ok, %{offset: %d, zone_abbr: "%s", dst: %s}}\n|,
      $dt->offset,
      $dt->time_zone_short_name,
      $dt->is_dst ? 'true' : 'false'
    );
  } else {
    printf(qq|{:ambiguous, |.
      qq|%{offset: %d, zone_abbr: "%s", dst: %s},|.
      qq|%{offset: %d, zone_abbr: "%s", dst: %s}}|,
      $od->offset, $od->time_zone_short_name, $od->is_dst ? 'true' : 'false',
      $dt->offset, $dt->time_zone_short_name, $dt->is_dst ? 'true' : 'false'
    );
  }

} or do {
  info("invalid date");
  my $od = $dt->clone;
  $dt->add(days => 1);
  $od->add(days => -1);

  $dt->set_time_zone($time_zone);
  $od->set_time_zone($time_zone);

  printf(qq|{:gap, |.
    qq|%{offset: %d, zone_abbr: "%s", dst: %s},|.
    qq|%{offset: %d, zone_abbr: "%s", dst: %s}}|,
    $od->offset, $od->time_zone_short_name, $od->is_dst ? 'true' : 'false',
    $dt->offset, $dt->time_zone_short_name, $dt->is_dst ? 'true' : 'false'
  )
};

sub info {
  my ($str) = @_;
  print("# $str\n")
}
