# TimeZoneInfo Basic Example

In this example, only the `:time_zone_info` dependency is included.

Open the console to test:
```
$> iex -S mix
Erlang/OTP 22 [erts-10.7] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Calendar.put_time_zone_database(TimeZoneInfo.TimeZoneDatabase)
:ok
iex(2)> {:ok, paris} = DateTime.from_naive(~N[2020-03-28 12:00:00], "Europe/Paris")
{:ok, #DateTime<2020-03-28 12:00:00+01:00 CET Europe/Paris>}
iex(3)> DateTime.shift_zone(paris, "America/New_York")
{:ok, #DateTime<2020-03-28 07:00:00-04:00 EDT America/New_York>}
iex(4)> TimeZoneInfo.next_update()
:never
iex(5)>
```
