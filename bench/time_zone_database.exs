defmodule Bench.TimeZoneDatabase do
  alias TimeZoneInfo.{DataStore, IanaParser, Transformer}

  @cwd File.cwd!()
  @data Code.eval_file("bench/data/333_ok_gap_ambiguous.exs", @cwd) |> elem(0)
  @seconds_per_year 31_622_400

  Code.require_file("test/support/time_zone_info/data_store/server.exs", @cwd)

  def run do
    setup_time_zone_info()

    Benchee.run(
      testees(),
      inputs: inputs(),
      title: "Benchmark: TimeZoneDatabase",
      formatters: formatters(),
      time: 10,
      memory_time: 2
    )
  end

  defp description do
    """
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
    - **ok_gap_ambiguous:** **ok**, **gap**, and **ambiguous** together.
    - **last_year:** 1000 `(datetime, time_zone)` arguments with random time zone
      and a date time from now to one year in the past. The data is calculated
      once for all test candidates.
    - **berlin_gap_2020**: Gaps in the time zone `Europe/Berlin` in 2020.
    - **berlin_ambiguous_2020**: Ambiguous date time in the time zone
      `Europe/Berlin` in 2020.

    The inputs **ok**, **gap**, and **ambiguous** containing random time zones
    and date times between 1900 and 2050.
    """
  end

  defp testees do
    %{
      time_zone_info_pst: &time_zone_info_pst/1,
      time_zone_info_ets: &time_zone_info_ets/1,
      time_zone_info_map: &time_zone_info_map/1,
      tz: &tz/1,
      tzdata: &tzdata/1
    }
  end

  defp inputs do
    %{
      ok_gap_ambiguous: ok_gap_ambiguous(),
      ok: Map.get(@data, :ok),
      gap: Map.get(@data, :gap),
      ambiguous: Map.get(@data, :ambiguous),
      last_year: last_year(),
      berlin_gap_2020: berlin_2020(:gap),
      berlin_ambiguous_2020: berlin_2020(:ambiguous)
    }
  end

  defp formatters do
    [
      Benchee.Formatters.Console,
      {Benchee.Formatters.Markdown,
       file: Path.expand("README.md", __DIR__), description: description()}
    ]
  end

  defp last_year do
    now = NaiveDateTime.utc_now()

    Enum.map(0..999, fn _ ->
      time_zone = Enum.random(TimeZoneInfo.time_zones())
      datetime = NaiveDateTime.add(now, :rand.uniform(@seconds_per_year) * -1)
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

    Enum.map(0..999, fn index ->
      {NaiveDateTime.add(datetime, index), "Europe/Berlin"}
    end)
  end

  defp setup_time_zone_info do
    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    time_zone_info_data =
      with {:ok, data} <- IanaParser.parse(path, files) do
        Transformer.transform(data, "2019c", lookahead: 5)
      end

    DataStore.PersistentTerm.put(time_zone_info_data)
    DataStore.ErlangTermStorage.put(time_zone_info_data)
    DataStore.Server.put(time_zone_info_data)
  end

  defp time_zone_info_pst(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  defp time_zone_info_ets(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.ErlangTermStorage)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  defp time_zone_info_map(data) do
    Application.put_env(:time_zone_info, :data_store, DataStore.Server)

    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  defp tz(data) do
    Enum.each(data, fn {datetime, time_zone} ->
      datetime
      |> Tz.TimeZoneDatabase.time_zone_periods_from_wall_datetime(time_zone)
      |> validate()
    end)
  end

  defp tzdata(data) do
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

  defp ok_gap_ambiguous do
    Enum.flat_map(@data, &elem(&1, 1))
  end
end
