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

  inputs %{
    "Europe/Berlin 2020-03-29 02:00:01 (gap)" => {~N[2020-03-29 02:00:01], "Europe/Berlin"},
    "Europe/Berlin 2020-10-25 02:00:01 (ambiguous)" => {~N[2020-10-25 02:00:01], "Europe/Berlin"},
    "Europe/Berlin 2020-06-01 00:00:00" => {~N[2020-06-06 00:00:00], "Europe/Berlin"},
    "Europe/Paris 1944-08-26 13:00:00" => {~N[1944-08-26 13:00:00], "Europe/Paris"}
  }

  formatter Benchee.Formatters.Markdown,
    file: Path.join("bench", Macro.underscore(__MODULE__) <> ".md"),
    description: @description

  job time_zone_info({datetime, time_zone}) do
    TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
  end

  job tz({datetime, time_zone}) do
    Tz.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
  end

  job tzdata({datetime, time_zone}) do
    Tzdata.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
  end

  job zoneinfo({datetime, time_zone}) do
    Zoneinfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(datetime, time_zone)
  end
end
