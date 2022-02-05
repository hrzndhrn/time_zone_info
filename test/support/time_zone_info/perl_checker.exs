defmodule TimeZoneInfo.PerlChecker do
  require Logger

  def period_from_utc(at, time_zone, expected),
    do: do_check(&period_from_utc/2, [at, time_zone], expected)

  def periods_from_wall(at, time_zone, expected),
    do: do_check(&periods_from_wall/2, [at, time_zone], expected)

  defp do_check(fun, args, expected) do
    with :ok <- blacklist(args) do
      result = apply(fun, args)

      case check(result, expected) do
        true -> {:valid, result}
        false -> {:invalid, result}
      end
    end
  end

  defp check(result, result), do: true

  defp check({:ok, period_a}, {:ok, period_x}) do
    check(period_a, period_x)
  end

  defp check({:ambiguous, period_a, period_b}, {:ambiguous, period_x, period_y}) do
    check(period_a, period_x) && check(period_b, period_y)
  end

  defp check({:gap, period_a, period_b}, {:gap, {period_x, limit_x}, {period_y, limit_y}}) do
    check_limit = NaiveDateTime.diff(limit_y, limit_x) == period_b.offset - period_a.offset
    check_limit && check(period_a, period_x) && check(period_b, period_y)
  end

  defp check(result, expected) when is_map(result) and is_map(expected) do
    check_abbr = result.zone_abbr == expected.zone_abbr
    check_offset = result.offset == expected.utc_offset + expected.std_offset
    check_dst = result.dst == (expected.std_offset != 0)

    check_offset && check_abbr && check_dst
  end

  defp check(_result, _expected), do: false

  defp blacklist([_date_time, "Etc" <> _etc]), do: :blacklist

  defp blacklist(_else), do: :ok

  defp period_from_utc(at, time_zone),
    do: perl("period_from_utc.pl", [time_zone, NaiveDateTime.to_iso8601(at)])

  defp periods_from_wall(at, time_zone),
    do: perl("periods_from_wall.pl", [time_zone, NaiveDateTime.to_iso8601(at)])

  defp perl(script, args) do
    script = Path.join("./test/support/perl", script)

    with {output, 0} <- System.cmd("perl", [script | args], stderr_to_stdout: true),
         {result, []} <- Code.eval_string(output) do
      result
    else
      _error -> {:error, :time_zone_not_found}
    end
  end
end
