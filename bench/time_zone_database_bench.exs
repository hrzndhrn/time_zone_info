defmodule TimeZoneDatabaseBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.DataStore

  @title "Benchmark: TimeZoneDatabase"

  @description """
  This benchmark compares `TimeZoneInfo` with
  - [`Tzdata`](https://github.com/lau/tzdata),
  - [`Tz`](https://github.com/mathieuprog/tz),
  - [`zoneinfo`](https://github.com/smartrent/zoneinfo)

  `TimeZoneInfo` is using `DataStore.PersistentTerm` in this benchmark.

  For the benchmark, each of them calls the function
  `TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

  It is relatively hard to compare these libs because the performance depends on
  the configurations of each lib. Therefore, the values here are a rough guide.
  """

  setup do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)
  end

  inputs %{
    "Europe/Berlin 2099-06-01 00:00:00" => {~N[2099-06-06 00:00:00], "Europe/Berlin"},
    "Europe/Berlin 2020-03-29 02:00:01 (gap)" => {~N[2020-03-29 02:00:01], "Europe/Berlin"},
    "Europe/Berlin 2020-10-25 02:00:01 (ambiguous)" => {~N[2020-10-25 02:00:01], "Europe/Berlin"},
    "Europe/Berlin 2020-06-01 00:00:00" => {~N[2020-06-01 00:00:00], "Europe/Berlin"},
    "Europe/Paris 1950-06-27 22:34:00" => {~N[1950-06-27 22:34:00], "Europe/Paris"}
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
