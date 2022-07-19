# Changelog

## 0.7.0 - dev

- Update `priv/data.etf` with IANA tzdata version 2021e.

## 0.6.1 - 2022/02/05

- Update `priv/data.etf` with IANA tzdata version 2021e.
- Add minor refactorings.

## 0.6.0 - 2021/09/25

- Update required Elixir version to `~> 1.10`
- Replace :crypto.hash/2 by :erlang.phash/1.
- Update `priv/data.etf` with IANA tzdata version 2021b.

## 0.5.3 - 2021/03/13

- Update `priv/data.etf` with IANA tzdata version 2021a.

## 0.5.3 - 2021/01/13

- Update `priv/data.etf` with IANA tzdata version 2020f.

## 0.5.2 - 2020/10/26

- Update `priv/data.etf` with IANA tzdata version 2020d.

## 0.5.1 - 2020/07/08

- Support different calendars.

## 0.5.0 - 2020/06/08

- Increasing speed of `TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.
- Adding `wall_time` to `time_zone_period`.
- Refactoring `updater` to fix some unexpected behaviours when changing configs.
- Updating docs structure.
- Adding `backward` to the default `files`.
- Refactoring `time_zones` configuration behaviour.
  See [Time zone maniputlation](https://hexdocs.pm/time_zone_info/config.html#time-zone-manipulation).

## 0.4.0 - 2020/04/25

- Updating `priv/data.etf` with IANA tzdata version 2020a.
- The Etc/UTC time-zone is always supported, no matter how the configuration is specified.
- Adding `TimeZoneInfo.DataPersistence.FileSystem`.
- Changing configuration option `format` to `mode`.
- Adding mode `:ws`. In this mode the `Downloader` will call a web service to
  fetch data.
- Adding `TimeZoneInfo.data/2`, this function generates `TimeZoneInfo.data` and
  is intended for use in a time-zone-info-server.
- Adding examples `TimeZoneInfoServer` and `Clock`.
- Making some modules private. According to [Hiding Internal Modules and Functions](https://hexdocs.pm/elixir/master/writing-documentation.html#hiding-internal-modules-and-functions).

## 0.3.0 - 2020/04/15

- Using `plug_cowboy` instead of `cowboy` in tests.
- Adding HTTP status code to the downloader.
- Updating default `lookahead` to 15 years.
- Refactoring date time handling.
- Adding `TimeZoneInfo.info/0`.
- Adding optional `info/0` callback to the `DataStore` behaviour.
- Adding optional `info/0` callback to the `DataPersistence` behaviour.
- Adding `TimeZoneInfo.Listener.ErrorLogger`.

## 0.2.0 - 2020/04/08

- Reimplementation of the `TimeZoneInfo.Transformer` to fix a bunch of bugs.
- Update parser to handle CRs.

## 0.1.1 - 2020/03/28

Fix github link in package.

## 0.1.0 - 2020/03/28

Initial release.
