defmodule TimeZoneInfo.ApplicationTest do
  use ExUnit.Case

  alias TimeZoneInfo.DataStore

  test "start" do
    assert {:ok, _} = Application.ensure_all_started(:time_zone_info)

    assert TimeZoneInfo.TimeZoneDatabase.time_zone_periods_from_wall_datetime(
             ~N[2012-09-01 12:00:00],
             "Europe/London"
           ) == {:ok, %{std_offset: 3600, utc_offset: 0, zone_abbr: "BST"}}

    assert TimeZoneInfo.state() == :ok
    assert TimeZoneInfo.update() == :ok
    assert TimeZoneInfo.update(:force) == :ok
    assert TimeZoneInfo.next_update() == :never
    assert %{persistence: _, store: _, worker: _} = TimeZoneInfo.info()
  end
end
