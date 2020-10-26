defmodule TimeZoneInfo.ApplicationTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  test "start" do
    put_env(
      files: [
        "africa",
        "antarctica",
        "asia",
        "australasia",
        "backward",
        "etcetera",
        "europe",
        "northamerica",
        "southamerica"
      ],
      time_zones: :all,
      lookahead: 15,
      data_store: :detect,
      update: :disabled,
      listener: TimeZoneInfo.Listener.ErrorLogger,
      downloader: [
        module: TimeZoneInfo.Downloader.Mint,
        uri: "https://data.iana.org/time-zones/tzdata-latest.tar.gz",
        mode: :iana,
        headers: [
          {"content-type", "application/gzip"},
          {"user-agent", "Elixir.TimeZoneInfo.Mint"}
        ]
      ],
      data_persistence: TimeZoneInfo.DataPersistence.Priv,
      priv: [path: "data.etf"]
    )

    assert {:ok, _} = Application.ensure_all_started(:time_zone_info)

    assert TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(
             ~N[2012-09-01 12:00:00],
             "Europe/London"
           ) == {
             :ok,
             %{
               std_offset: 3600,
               utc_offset: 0,
               zone_abbr: "BST",
               wall_period: {~N[2012-03-25 02:00:00], ~N[2012-10-28 02:00:00]}
             }
           }

    assert TimeZoneInfo.state() == :ok
    assert TimeZoneInfo.update() == :ok
    assert TimeZoneInfo.update(:force) == :ok
    assert TimeZoneInfo.next_update() == :never
    assert %{persistence: _, store: _, worker: _} = TimeZoneInfo.info()
  end
end
