defmodule TimeZoneInfo.TimeZoneDatabaseCase do
  use ExUnit.CaseTemplate

  alias TimeZoneInfo.{
    Checker,
    DataStore,
    IanaParser,
    NaiveDateTimeUtil,
    TimeZoneDatabase,
    Transformer
  }

  @default_data_store TimeZoneInfo.DataStore.Server
  using(opts) do
    data_store = Keyword.get(opts, :data_store, @default_data_store)

    quote do
      use ExUnitProperties

      import TimeZoneInfo.TimeZoneDatabaseCase
      import TimeZoneInfo.NaiveDateTimeUtil, only: [to_iso_days: 1]

      require Logger

      setup_all do
        Application.put_env(:time_zone_info, :data_store, unquote(data_store))

        path = "test/fixtures/iana/2019c"
        files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

        data =
          with {:ok, parsed} <- IanaParser.parse(path, files) do
            Transformer.transform(parsed, "2019c", lookahead: 1)
          end

        DataStore.put(data)

        %{data: data}
      end
    end
  end

  defmacro prove(desc \\ nil, code)

  defmacro prove(
             desc,
             {:==, _,
              [{:time_zone_periods_from_wall_datetime, _, [datetime, time_zone]}, expected]}
           ) do
    desc = if desc == nil, do: "returns periods for", else: desc
    {:sigil_N, _, [{_, _, [datetime_str]}, []]} = datetime

    quote do
      test "#{unquote(desc)} #{unquote(time_zone)} at #{unquote(datetime_str)}" do
        assert TimeZoneDatabase.time_zone_periods_from_wall_datetime(
                 unquote(datetime),
                 unquote(time_zone)
               ) == unquote(expected)

        Checker.periods_from_wall(unquote(datetime), unquote(time_zone), unquote(expected))
      end
    end
  end

  defmacro prove(
             desc,
             {:==, _, [{:time_zone_period_from_utc_iso_days, _, [datetime, time_zone]}, expected]}
           ) do
    desc = if desc == nil, do: "returns period for", else: desc
    {:sigil_N, _, [{_, _, [datetime_str]}, []]} = datetime

    quote do
      test "#{unquote(desc)} #{unquote(time_zone)} at #{unquote(datetime_str)}" do
        assert TimeZoneDatabase.time_zone_period_from_utc_iso_days(
                 to_iso_days(unquote(datetime)),
                 unquote(time_zone)
               ) == unquote(expected)

        Checker.period_from_utc(unquote(datetime), unquote(time_zone), unquote(expected))
      end
    end
  end

  defmacro property_time_zone_period_from_utc_iso_days(time_zone: time_zone) do
    quote do
      property "returns valid tuple for time zone #{unquote(time_zone)}" do
        check all at <- datetime(~N[1900-01-01 00:00:00], ~N[2050-01-01 00:00:00]) do
          assert {:ok, period} =
                   TimeZoneDatabase.time_zone_period_from_utc_iso_days(
                     NaiveDateTimeUtil.to_iso_days(at),
                     unquote(time_zone)
                   )

          assert_time_zone_period(period)

          Checker.period_from_utc(at, unquote(time_zone), {:ok, period})
        end
      end
    end
  end

  defmacro property_time_zone_period_from_utc_iso_days(from: from, to: to) do
    quote do
      from_str = NaiveDateTime.to_iso8601(unquote(from))
      to_str = NaiveDateTime.to_iso8601(unquote(to))
      info = "in time span #{from_str} - #{to_str}"

      property "returns valid tuple for a time zone #{info}" do
        check all {at, time_zone} <- time_zone_datetime(unquote(from), unquote(to)) do
          assert {:ok, period} =
                   TimeZoneDatabase.time_zone_period_from_utc_iso_days(
                     NaiveDateTimeUtil.to_iso_days(at),
                     time_zone
                   )

          assert_time_zone_period(period)

          Checker.period_from_utc(at, time_zone, {:ok, period})
        end
      end
    end
  end

  defmacro property_time_zone_periods_from_wall_datetime(time_zone: time_zone) do
    quote do
      property "returns valid tuple for time zone #{unquote(time_zone)}" do
        check all at <- datetime(~N[1900-01-01 00:00:00], ~N[2050-01-01 00:00:00]) do
          assert periods =
                   TimeZoneDatabase.time_zone_periods_from_wall_datetime(at, unquote(time_zone))

          assert_time_zone_periods(periods)

          Checker.periods_from_wall(at, unquote(time_zone), periods)
        end
      end
    end
  end

  defmacro property_time_zone_periods_from_wall_datetime(from: from, to: to) do
    quote do
      from_str = NaiveDateTime.to_iso8601(unquote(from))
      to_str = NaiveDateTime.to_iso8601(unquote(to))

      property "returns valid tuple for a time zone in time span #{from_str} to #{to_str}" do
        check all {at, time_zone} <- time_zone_datetime(unquote(from), unquote(to)) do
          assert periods = TimeZoneDatabase.time_zone_periods_from_wall_datetime(at, time_zone)

          assert_time_zone_periods(periods)

          Checker.periods_from_wall(at, time_zone, periods)
        end
      end
    end
  end

  def assert_time_zone_periods({:ok, time_zone_period}) do
    assert_time_zone_period(time_zone_period)
  end

  def assert_time_zone_periods({:ambiguous, time_zone_period_a, time_zone_period_b}) do
    assert_time_zone_period(time_zone_period_a)
    assert_time_zone_period(time_zone_period_b)
  end

  def assert_time_zone_periods(
        {:gap, {time_zone_period_a, limit_a}, {time_zone_period_b, limit_b}}
      ) do
    assert_time_zone_period(time_zone_period_a)
    assert_time_zone_period(time_zone_period_b)
    assert NaiveDateTimeUtil.before?(limit_a, limit_b)
  end

  def assert_time_zone_periods(invalid) do
    flunk("invalid time zone periods: #{inspect(invalid)}")
  end

  def assert_time_zone_period(time_zone_period) do
    assert Map.keys(time_zone_period) == ~w(std_offset utc_offset zone_abbr)a

    assert %{std_offset: std_offset, utc_offset: utc_offset, zone_abbr: zone_abbr} =
             time_zone_period

    assert std_offset in [-3600, 0, 1200, 1800, 3600, 5400, 7200]
    assert utc_offset >= -57360 && utc_offset <= 54822
    assert String.length(zone_abbr) <= 6
  end

  # property generators

  def datetime(from, to) do
    diff = NaiveDateTime.diff(to, from)

    StreamData.map(StreamData.constant(nil), fn _ ->
      NaiveDateTime.add(from, :rand.uniform(diff), :second)
    end)
  end

  def time_zone_datetime(from, to) do
    time_zones = TimeZoneInfo.time_zones()
    diff = NaiveDateTime.diff(to, from)

    StreamData.map(StreamData.constant(nil), fn _ ->
      time_zone = Enum.random(time_zones)
      at = NaiveDateTime.add(from, :rand.uniform(diff), :second)

      {at, time_zone}
    end)
  end
end
