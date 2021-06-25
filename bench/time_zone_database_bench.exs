defmodule TimeZoneDatabaseBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore

  @title "Benchmark: TimeZoneDatabase"

  @description """
  This benchmark compares `TimeZoneInfo` with
  [`Tzdata`](https://github.com/lau/tzdata),
  [`Tz`](https://github.com/mathieuprog/tz),
  and [`zoneinfo`](https://github.com/smartrent/zoneinfo)

  `TimeZoneInfo` is using
  `DataStore.PersistentTerm` in this benchmark.

  All testees have an implementation for `TimeZoneDatabas`. For the benchmark,
  each of them calls the function
  `TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

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

  The inputs **world_ok**, **world_gap**, and **world_ambiguous** containing
  random time zones and date times between 1900 and 2050.
  """

  setup do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)
  end

  inputs Data.inputs()

  formatter Benchee.Formatters.Markdown,
    file: Path.join("bench", Macro.underscore(__MODULE__) <> ".md"),
    description: @description

  job time_zone_info(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end

  job tz(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      Tz.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end

  job tzdata(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      Tzdata.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end

  job zoneinfo(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      Zoneinfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
    end)
  end
end
