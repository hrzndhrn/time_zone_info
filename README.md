# TimeZoneInfo
[![Hex.pm](https://img.shields.io/hexpm/v/time_zone_info.svg)](https://hex.pm/packages/time_zone_info)
[![Build Status](https://travis-ci.org/hrzndhrn/time_zone_info.svg?branch=master)](https://travis-ci.org/hrzndhrn/time_zone_info)
[![Coverage Status](https://coveralls.io/repos/github/hrzndhrn/time_zone_info/badge.svg?branch=master)](https://coveralls.io/github/hrzndhrn/time_zone_info?branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Time zone support for Elixir by using the
[IANA Time Zone Database](https://www.iana.org/time-zones).

## Installation

The package can be installed by adding `time_zone_info` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:time_zone_info, "~> 0.2"}
  ]
end
```

## Usage

After installation, `TimeZoneInfo` can be used as follows.
```
iex> TimeZoneInfo.iana_version
"2019c"
iex> TimeZoneInfo.time_zones() |> Enum.take(3)
["Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa"]
iex> TimeZoneInfo.period_from_utc(~N[2020-03-29 01:30:00], "Europe/Berlin")
{:ok, {3600, 3600, "CEST"}}
```

In combination with `DateTime` and `Calendar`:
```
iex> {:ok, berlin} = DateTime.from_naive(
...>   ~N[2020-03-29 01:30:00],
...>   "Europe/Berlin",
...>    TimeZoneInfo.TimeZoneDatabase)
{:ok, #DateTime<2020-03-29 01:30:00+01:00 CET Europe/Berlin>}
iex> Calendar.put_time_zone_database(TimeZoneInfo.TimeZoneDatabase)
:ok
iex> DateTime.shift_zone(berlin, "America/New_York")
{:ok, #DateTime<2020-03-28 20:30:00-04:00 EDT America/New_York>}
```

Instead of the line
`Calendar.put_time_zone_database(TimeZoneInfo.TimeZoneDatabase)` you can also
specify the following entry in the configuration.
```
config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase
```

For more information how to configure `TimeZoneInfo` see
[Config](https://hexdocs.pm/time_zone_info/config.html). The site shows how to
enable automated updates, filter time zones, and add custom `behaviour`s.

## Benchmarks

The benchmarks can be executed with `mix bench`.

A [benchmark](bench/README.md) to compare `TimeZoneInfo` with `Tzdata` and `Tz`
for the execution of `TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

A [benchmark](bench/trnasformer.md) to measure the speed of the transformation
of the raw IANA data to the required data in runtime.

## Differences to Tzdata and Tz

There are some differences to `Tzdata` and `Tz`. The list shows differences to
`Tzdata` and/or `Tz`.

- Use of `:persitent_term` with an optional use of `:ets`.
- Persisting data in
  [External Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html)
- The data persisting is customizable by the behaviour
  `TimeZoneInfo.DataPersistence`.
- Optional download of time zone data in `TimeZoneInfo` format.
- The download is customizable by the behaviour `TimeZoneInfo.Downloader`.
- Filter time zones per config.
- Optional listener that will be called on updates.
- `TimeZoneInfo` calculates periods in the far future by continuation rules.
  Except for time zones that have daylight saving times for Ramadan.

## References

The home of the IANA Time Zone Database: https://www.iana.org/time-zones

Links:
- [Time zone](https://en.wikipedia.org/wiki/Time_zone) - Wikipedia
- [**time**and**date**.com](https://www.timeanddate.com/)
- [WorldTimeServer.com](https://www.worldtimeserver.com/)

Other Elixir implementations:
- [tzdata](https://github.com/lau/tzdata) - Tzdata is a parser and library for
  the tz database.
- [tz](https://github.com/mathieuprog/tz) - Time zone support for Elixir

Other implementations:
- [DateTime::TimeZone](https://github.com/houseabsolute/DateTime-TimeZone) - Perl
  - `TimeZoneInfo` use this module as a checker in the tests.
- [NodaTime](https://nodatime.org/) - A better date and time API for .NET
  - `TimeZonInfo` use some data from this
    [site](https://nodatime.org/tzvalidate/generate?version=2019c) in the tests.
