defmodule StoresBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore

  @title "Benchmark: TimeZoneDatabase"

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

  @datetime ~N[2021-06-01 00:00:00]
  @time_zone "Europe/Berlin"

  # `Application.put_env should` be run in `before_scenario` as soon as this is
  # available in `benchee_dsl`.

  job ets do
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)
    TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(@datetime, @time_zone)
  end

  job pst do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)
    TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(@datetime, @time_zone)
  end

  job map do
    Application.put_env(:time_zone_info, :data_store, DataStore.Server)
    TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(@datetime, @time_zone)
  end
end
