defmodule TimeZoneDatabaseBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.{DataStore, IanaParser, Transformer}

  @title "Benchmark: TimeZoneDatabase"

  @description """
  This benchmark compares `TimeZoneInfo` with
  [`Tzdata`](https://github.com/lau/tzdata) and
  [`Tz`](https://github.com/mathieuprog/tz).

  The `TimeZoneInfo` will be tested in three different configurations.
  Each version uses a different strategy to keep the data available.
  - `time_zone_info_pst` is using
    [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
  - `time_zone_info_ets` is using `:ets`
    [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
  - `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
    version isn't an available configuration in `TimeZoneInfo`. The
    `GenServer` version is otherwise only used in the tests.

  All testees have an implementation for `TimeZoneDatabas`. For the benchmark,
  each of them calls the function
  `TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

  The inputs for every benchmark run:
  - **ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
    `:ok` return value.
  - **gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
    `:gap` return tuple.
  - **ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
    a `:ambiguous` return tuple.
  - **last_year:** 333 `(datetime, time_zone)` arguments with random time zone
    and a date time from now to one year in the past. The data is calculated
    once for all test candidates.
  - **berlin_gap_2020**: 333 gaps in the time zone `Europe/Berlin` in 2020.
  - **berlin_ambiguous_2020**: 333 ambiguous date time in the time zone
    `Europe/Berlin` in 2020.

  The inputs **ok**, **gap**, and **ambiguous** containing random time zones
  and date times between 1900 and 2050.
  """

  setup do
    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    time_zone_info_data =
      case IanaParser.parse(path, files) do
        {:ok, data} ->
          Transformer.transform(data, "2019c", lookahead: 5)

        {:error, _} ->
          raise "Can not parse '#{path}'!"
      end

    DataStore.PersistentTerm.put(time_zone_info_data)
    DataStore.ErlangTermStorage.put(time_zone_info_data)
    DataStore.Server.put(time_zone_info_data)
  end

  inputs do
    data = Code.eval_file("bench/data/333_ok_gap_ambiguous.exs") |> elem(0)

    %{
      ok: Map.get(data, :ok),
      gap: Map.get(data, :gap),
      ambiguous: Map.get(data, :ambiguous),
      berlin_gap_2020: berlin_2020(:gap),
      berlin_ambiguous_2020: berlin_2020(:ambiguous),
      last_year: last_year()
    }
  end

  job time_zone_info_ets(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  job time_zone_info_pst(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  job time_zone_info_map(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.Server)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  job tz(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> Tz.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  job tzdata(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> Tzdata.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  defp validate(result) do
    case elem(result, 0) do
      :ok -> :ok
      :gap -> :ok
      :ambiguous -> :ok
      _ -> raise "fail: #{inspect(result)}"
    end
  end

  defp last_year do
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)
    seconds_per_year = 31_622_400
    now = NaiveDateTime.utc_now()

    Enum.map(0..333, fn _ ->
      time_zone = Enum.random(TimeZoneInfo.time_zones())
      datetime = NaiveDateTime.add(now, :rand.uniform(seconds_per_year) * -1)
      {datetime, time_zone}
    end)
  end

  defp berlin_2020(mode) do
    datetime =
      case mode do
        :gap ->
          ~N[2020-03-29 02:00:01]

        :ambiguous ->
          ~N[2020-10-25 02:00:01]
      end

    Enum.map(0..333, fn index ->
      {NaiveDateTime.add(datetime, index), "Europe/Berlin"}
    end)
  end
end
