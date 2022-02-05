defmodule TimeZoneInfo.Checker do
  import ExUnit.Assertions
  require Logger

  def periods_from_wall(datetime, time_zone, expected),
    do: check(:periods_from_wall, datetime, time_zone, expected)

  def period_from_utc(datetime, time_zone, expected),
    do: check(:period_from_utc, datetime, time_zone, expected)

  defp check(fun, datetime, time_zone, expected) when is_atom(fun) do
    info = """
    Checker: #{inspect(fun)}
    input: #{inspect(datetime)}, #{inspect(time_zone)}
    expected: #{inspect(expected)}\
    """

    result =
      config()
      |> Enum.map(fn checker_config ->
        check(checker_config, fun, [datetime, time_zone, update(expected)], info)
      end)
      |> join()

    case result do
      {:valid, ""} ->
        :ok

      {validation, message} ->
        message = "#{info}\n#{message}"

        case validation do
          :invalid -> Logger.error(message)
          :valid -> Logger.info(message)
        end
    end
  end

  defp check(config, fun, args, info) do
    case config[:active] do
      true ->
        mod = config[:mod]

        message = mod |> apply(fun, args) |> message(mod, info?(config))

        case config[:assert] do
          false -> message
          true -> check_assert(message, info)
        end

      _flag ->
        {:valid, ""}
    end
  end

  defp check_assert(message, info) do
    case message do
      {:error, message} -> flunk("#{info}\n#{message}")
      message -> message
    end
  end

  defp info?(config), do: config[:info] || false

  defp message(:blacklist, _mod, _info), do: {:blacklist, nil}

  defp message({validation, result}, mod, info) when validation == :invalid or info == true do
    {validation, "#{inspect(mod)}\nresult: #{inspect(result)}"}
  end

  defp message({:valid, _result}, _mod, _info), do: {:valid, ""}

  defp join(results, flag \\ :valid, acc \\ [])

  defp join([], flag, acc), do: {flag, acc |> Enum.reverse() |> Enum.join("\n")}

  defp join([{:blacklist, _result} | results], flag, acc) do
    join(results, flag, acc)
  end

  defp join([{validation, result} | results], flag, acc) when validation in [:valid, :invalid] do
    flag = if validation == :invalid || flag == :invalid, do: :invalid, else: :valid
    acc = if result == "", do: acc, else: [result | acc]

    join(results, flag, acc)
  end

  defp config, do: Application.get_env(:time_zone_info, :checker)

  defp update(data) do
    case data do
      {:ok, period} ->
        {:ok, time_zone_period(period)}

      {:gap, {period_a, limit_a}, {period_b, limit_b}} ->
        {:gap, {time_zone_period(period_a), limit_a}, {time_zone_period(period_b), limit_b}}

      {:ambiguous, period_a, period_b} ->
        {:ambiguous, time_zone_period(period_a), time_zone_period(period_b)}

      data ->
        data
    end
  end

  defp time_zone_period({utc_offset, std_offset, zone_abbr}),
    do: %{utc_offset: utc_offset, std_offset: std_offset, zone_abbr: zone_abbr}

  defp time_zone_period(period), do: period
end
