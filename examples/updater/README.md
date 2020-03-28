# TimeZoneInfo Updater Example

In this example `TimeZoneInfo` is configured for automated updates. Therefore
the packages `:castore` and `:mint` are also added to the deps.

Run `mix run` to test:
```
$> mix run

11:20:27.864 [info]  TimeZoneInfo: Initializing data.

11:20:27.883 [info]  TimeZoneInfo: Checking for update.

11:20:27.896 [info]  Paris: #DateTime<2020-03-25 12:00:00+01:00 CET Europe/Paris>

11:20:27.896 [info]  New York: #DateTime<2020-03-25 07:00:00-04:00 EDT America/New_York>
```

Or run `iex -S mix`:
```
$> iex -S mix
Erlang/OTP 22 [erts-10.7] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]
...
Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> DateTime.now("Europe/Warsaw")
{:ok,
 #DateTime<2020-03-28 08:34:48.401245+01:00 CET Europe/Warsaw>}
iex(2)> TimeZoneInfo.next_update
~U[2020-03-29 06:56:05Z]
iex(3)> TimeZoneInfo.update

08:35:28.853 [info]  TimeZoneInfo: Checking for update.
{:next, ~U[2020-03-29 06:56:05Z]}
iex(4)> TimeZoneInfo.update(:force)

08:35:39.920 [info]  TimeZoneInfo: Downloading data.

08:35:41.962 [info]  TimeZoneInfo: Updating data.
{:next, ~U[2020-03-29 07:35:39Z]}
iex(5)>
```
