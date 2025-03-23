# Changelog

## 0.7.8 - 2025/03/23

- Update `priv/data.etf` with IANA tzdata version 2025b.

## 0.7.7 - 2025/01/19

- Update `priv/data.etf` with IANA tzdata version 2025a.
- Requrie Elixir 1.13

## 0.7.6 - 2024/09/14

- Refactor `TimeZoneInfo.IanaParser` to handle names correctly.
  The correct handling is documented in the man for `zic`:
  Names must be in English and are case insensitive. They appear in several 
  contexts, and include month and weekday names and keywords such as maximum, 
  only, Rolling, and Zone. A name can be abbreviated by omitting all but an 
  initial prefix; any abbreviation must be unambiguous in context.

## 0.7.5 - 2024/09/08

- Fix warning by conditionally compiling `TimeZoneInfo.Downloader.Mint`.

## 0.7.4 - 2024/09/08

- Update `priv/data.etf` with IANA tzdata version 2024b.
- Update the parser to accept months and days also  as a full name.
- Add support for zome abbr format `%z`.

## 0.7.3 - 2024/05/09

- Update `priv/data.etf` with IANA tzdata version 2024a.

## 0.7.2 - 2024/01/12

- Update `priv/data.etf` with IANA tzdata version 2023d.

## 0.7.1 - 2023/12/24

- Bump required Elixir version to 1.12.

## 0.7.0 - 2023/11/03

- Bump required Elixir version to 1.11.
- Use `Calenadar.ISO.day_of_week/4`.
- Refactor `TimeZoneInfo.DataStore.PersistentTerm`

## 0.6.5 - 2023/05/10

- Update `priv/data.etf` with IANA tzdata version 2023c.

## 0.6.4 - 2022/11/09

- Fix bug for negative dates.

## 0.6.3 - 2022/10/31

- Update `priv/data.etf` with IANA tzdata version 2022f.

## 0.6.2 - 2022/07/24

- Update `priv/data.etf` with IANA tzdata version 2022a.
- Update `TimeZoneInfo.DataPersistence.Priv`.

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
