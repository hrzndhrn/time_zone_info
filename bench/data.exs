defmodule Data do
  @moduledoc false

  alias TimeZoneInfo.DataStore

  def inputs do
    data = Code.eval_file("bench/data/333_ok_gap_ambiguous.exs") |> elem(0)

    %{
      world_ok: Map.get(data, :ok),
      world_gap: Map.get(data, :gap),
      world_ambiguous: Map.get(data, :ambiguous),
      world_last_year: last_year(),
      berlin_gap_2020: berlin_2020(:gap),
      berlin_ambiguous_2020: berlin_2020(:ambiguous),
      berlin_ok_2020: berlin_2020(:ok)
    }
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
        :ok ->
          ~N[2020-06-25 00:00:00]
      end

    Enum.map(0..333, fn index ->
      {NaiveDateTime.add(datetime, index), "Europe/Berlin"}
    end)
  end
end
