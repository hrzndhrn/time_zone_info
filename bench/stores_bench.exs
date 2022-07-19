defmodule StoresBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore
  alias TimeZoneInfo.TimeZoneDatabase

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
    title: @title,
    description: @description

  inputs %{"Europe/Berlin" => [~N[2021-06-01 00:00:00], "Europe/Berlin"]}

  @before_scenario fn ->
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)
  end
  job &TimeZoneDatabase.time_zone_periods_from_wall_datetime/2, as: :ets

  @before_scenario fn ->
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)
  end
  job &TimeZoneDatabase.time_zone_periods_from_wall_datetime/2, as: :pst

  @before_scenario fn ->
    Application.put_env(:time_zone_info, :data_store, DataStore.Server)
  end
  job &TimeZoneDatabase.time_zone_periods_from_wall_datetime/2, as: :map
end
