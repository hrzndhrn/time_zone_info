defmodule StoresBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore

  @title "Benchmark: TimeZoneDatabase Storage"

  @description """
  This benchmark compares the different `DataStores` available in
  `TimeZoneInfo`.

  The `TimeZoneInfo` will be tested in three different configurations.
  Each version uses a different strategy to keep the data available.
  - `pst` is using
    [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
  - `ets` is using `:ets`
    [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
  - `map` is using a `GenServer` with a `Map` as state. This
    version isn't an available configuration in `TimeZoneInfo`. The
    `GenServer` version is otherwise only used in the tests.
  """

  formatter Benchee.Formatters.Markdown,
    file: Path.join("bench", Macro.underscore(__MODULE__) <> ".md"),
    description: @description

  @before fn -> Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage) end
  job &run/0, as: :ets

  @before fn -> Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm) end
  job &run/0, as: :pst

  @before fn -> Application.put_env(:time_zone_info, :data_store, DataStore.Server) end
  job &run/0, as: :map

  defp run do
    TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(
      ~N[2021-06-01 00:00:00],
      "Europe/Berlin"
    )
  end
end
