# TimeZoneInfo Server Example

This example shows a server that provides a web service that returns time zones
data under the URI `http://localhost:4001/api/time_zone_info`. The example
[Clock](../example/clock) uses this web service.

The server can be started with `mix run --no-halt` or `iex -S mix`.

The server contains the module `FakeUtcDateTime`, which the server uses for the
current date-time, and that can be set for tests.

```
> iex -S mix
iex> FakeUtcDateTime.put(~U[2020-04-25 12:00:00Z])
:ok
```
