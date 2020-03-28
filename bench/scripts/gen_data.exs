defmodule GenData do
  alias TimeZoneInfo.{DataStore, IanaParser, Transformer, TimeZoneDatabase}

  @output_path "bench/data"
  @output_file "333_ok_gap_ambiguous.exs"
  @limit 333
  @from 1900
  @to 2050

  def run do
    prepare_time_zone_info()

    data = generate(%{ok: [], ambiguous: [], gap: []}, 0)

    @output_path
    |> path()
    |> Path.join(@output_file)
    |> File.write!(data |> inspect(limit: :infinity) |> Code.format_string!())
  end

  defp generate(acc, count) do
    count = count + 1
    IO.puts("##{count}")
    IO.puts("ok: #{length(acc.ok)}, gap: #{length(acc.gap)}, ambiguous: #{length(acc.ambiguous)}")

    case length(acc.ok) == @limit && length(acc.ambiguous) == @limit && length(acc.gap) == @limit do
      true ->
        acc

      false ->
        naive_datetime = random_naive_datetime()
        time_zone = random_time_zone()
        IO.puts(inspect({naive_datetime, time_zone}))

        case TimeZoneDatabase.time_zone_periods_from_wall_datetime(naive_datetime, time_zone) do
          {:ok, _} ->
            case length(acc.ok) < @limit do
              true ->
                acc |> Map.put(:ok, [{naive_datetime, time_zone} | acc.ok]) |> generate(count)

              false ->
                generate(acc, count)
            end

          {:gap, _, _} ->
            case length(acc.gap) < @limit do
              true ->
                acc |> Map.put(:gap, [{naive_datetime, time_zone} | acc.gap]) |> generate(count)

              false ->
                generate(acc, count)
            end

          {:ambiguous, _, _} ->
            case length(acc.ambiguous) < @limit do
              true ->
                acc
                |> Map.put(:ambiguous, [{naive_datetime, time_zone} | acc.ambiguous])
                |> generate(count)

              false ->
                generate(acc, count)
            end
        end
    end
  end

  defp prepare_time_zone_info do
    Application.put_env(:time_zone_info, :data_store, DataStore.PersistentTerm)

    path = path("test/fixtures/iana/2019c")
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    with {:ok, data} <- IanaParser.parse(path, files) do
      data
      |> Transformer.transform("2019c", lookahead: 15)
      |> DataStore.put()
    end
  end

  defp path(path), do: Path.join(File.cwd!(), path)

  defp random_time_zone, do: Enum.random(TimeZoneInfo.time_zones())

  defp random_naive_datetime do
    {:ok, datetime} =
      NaiveDateTime.new(
        Enum.random(@from..@to),
        Enum.random([3, 10]),
        Enum.random(1..31),
        Enum.random(0..23),
        Enum.random(0..59),
        Enum.random(0..59)
      )

    datetime
  end
end

GenData.run()
