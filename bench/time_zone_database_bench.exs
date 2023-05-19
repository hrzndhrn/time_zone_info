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
    "Europe/Berlin 2099-06-01 00:00:00" => [~N[2099-06-06 00:00:00], "Europe/Berlin"],
    "Europe/Berlin 2024-03-31 02:00:01 (gap)" => [~N[2024-03-31 02:00:01], "Europe/Berlin"],
    "Europe/Berlin 2024-10-27 02:00:01 (ambiguous)" => [~N[2024-10-27 02:00:01], "Europe/Berlin"],
    "Europe/Berlin 2024-06-01 00:00:00" => [~N[2024-06-01 00:00:00], "Europe/Berlin"],
    "Europe/Paris 1950-06-27 22:34:00" => [~N[1950-06-27 22:34:00], "Europe/Paris"]
  }

  formatter Benchee.Formatters.Markdown,
    file: Path.join(["bench", "reports", Macro.underscore(__MODULE__) <> ".md"]),
    title: @title,
    description: @description

  job &TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime/2,
    as: :time_zone_info

  job &Tz.TimeZoneDatabase.time_zone_periods_from_wall_datetime/2,
    as: :tz

  job &Tzdata.TimeZoneDatabase.time_zone_periods_from_wall_datetime/2,
    as: :tzdata

  job &Zoneinfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime/2,
    as: :zoninfo
end
