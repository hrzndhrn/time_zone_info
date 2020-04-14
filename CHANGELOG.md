# Changelog

## 0.2.0-dev

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
