defmodule StoresBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore

  @title "Benchmark: TimeZoneDatabase"

  @description """
  This benchmark compares the different `DataStores` available in
  `TimeZoneInfo`.

  The `TimeZoneInfo` will be tested in three different configurations.
  Each version uses a different strategy to keep the data available.
  - `time_zone_info_pst` is using
    [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
  - `time_zone_info_ets` is using `:ets`
    [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
  - `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
    version isn't an available configuration in `TimeZoneInfo`. The
    `GenServer` version is otherwise only used in the tests.

  The inputs for every benchmark run:
  - **world_ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
    `:ok` return value.
  - **world_gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
    `:gap` return tuple.
  - **world_ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
    a `:ambiguous` return tuple.
  - **world_last_year:** 333 `(datetime, time_zone)` arguments with random time zone
    and a date time from now to one year in the past. The data is calculated
    once for all test candidates.
  - **berlin_gap_2020**: 333 gaps in the time zone `Europe/Berlin` in 2020.
  - **berlin_ambiguous_2020**: 333 ambiguous date time in the time zone
    `Europe/Berlin` in 2020.

  The inputs **ok**, **gap**, and **ambiguous** containing random time zones
  and date times between 1900 and 2050.
  """

  inputs Data.inputs()

  job time_zone_info_ets(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)

    Enum.each(data, fn {datetime, time_zone} ->
      TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end

  job time_zone_info_pst(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)

    Enum.each(data, fn {datetime, time_zone} ->
      TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end

  job time_zone_info_map(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.Server)

    Enum.each(data, fn {datetime, time_zone} ->
      TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end
end
