# TimeZoneInfo Clock Example

This example needs a started [TimeZoneInfo Server](../../examples/time_zone_info_server).

This example comes with some more [configuration](confi/config.exs) as the other
examples.

The clock is far simple; it has just three functions.

`Clock.display/0` shows the date and time (quelle surprise) along with some debug
logs. The other functions are `Clock.put_time_zone/1` and `Clock.get_time_zone/1`.

```
iex> Clock.display()
[debug] utc: 2020-04-23 18:43:03Z
[debug] period: {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "UTC"}}
 Clock: 2020-04-23 18:43:03Z
:ok
iex> Clock.put_time_zone("Europe/Berlin")
:ok
iex> Clock.display
[debug] utc: 2020-04-23 18:45:15Z
[debug] period: {:ok, %{std_offset: 3600, utc_offset: 3600, zone_abbr: "CEST"}}
 Clock: 2020-04-23 20:45:15+02:00 CEST Europe/Berlin
:ok
```

The example is intended to play around with `TimeZoneInfo.update()` and
`TimeZoneInfo.update(:force)`.

The date-time for the `Clock` and `TimeZoneInfo` can be faked with
`FakeUtcDatetime.put(~U[2020-04-26 11:22:33Z])`.

```
iex> TimeZoneInfo.update()
[info] TimeZoneInfo: Checking for update.
[info] TimeZoneInfo: No update required.
{:next, 86332000}
iex> FakeUtcDateTime.put(~U[2020-04-27 19:00:00Z])
:ok
iex> TimeZoneInfo.update()
[info] TimeZoneInfo: Checking for update.
[info] TimeZoneInfo: Downloading data.
[info] TimeZoneInfo: No update available.
{:next, 86399000}
```

