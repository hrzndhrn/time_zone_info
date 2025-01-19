defmodule TimeZoneInfo.TimeZoneDatabaseChecker do
  defmacro __using__(opts) do
    quote do
      import TimeZoneInfo.TestUtils, only: [to_iso_days: 1]

      @module unquote(opts[:module])
      alias unquote(opts[:module]).TimeZoneDatabase

      def periods_from_wall(datetime, time_zone, expected) do
        case check?(@module, datetime, time_zone) do
          true ->
            do_check(:time_zone_periods_from_wall_datetime, [datetime, time_zone], expected)

          false ->
            {:valid, expected}
        end
      end

      def period_from_utc(datetime, time_zone, expected) do
        case check?(@module, datetime, time_zone) do
          true ->
            do_check(
              :time_zone_period_from_utc_iso_days,
              [to_iso_days(datetime), time_zone],
              expected
            )

          false ->
            {:valid, expected}
        end
      end

      defp do_check(fun, args, expected) do
        TimeZoneDatabase
        |> apply(fun, args)
        |> strip()
        |> check(strip(expected))
      rescue
        error ->
          {:invalid, {:error, error}}
      end

      defp check(result, result), do: {:valid, result}

      defp check(result, _), do: {:invalid, result}

      defp strip({:ok, data}), do: {:ok, strip(data)}

      defp strip({:gap, {a, b}, {x, y}}), do: {:gap, {strip(a), b}, {strip(x), y}}

      defp strip({:ambiguous, a, b}), do: {:ambiguous, strip(a), strip(b)}

      defp strip(%{std_offset: std_offset, utc_offset: utc_offset, zone_abbr: zone_abbr}) do
        %{std_offset: std_offset, utc_offset: utc_offset, zone_abbr: zone_abbr}
      end

      defp strip(data), do: data

      defp check?(module, datetime, _time_zone) do
        if module == Tz do
          datetime.year <= NaiveDateTime.utc_now().year
        else
          true
        end
      end
    end
  end
end
