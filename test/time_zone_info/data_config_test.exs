defmodule TimeZoneInfo.DataConfigTest do
  use ExUnit.Case

  alias TimeZoneInfo.{
    DataConfig,
    ExternalTermFormat
  }

  setup_all do
    {:ok, data} =
      "test/fixtures/data/2019c/data.etf"
      |> File.read!()
      |> ExternalTermFormat.decode()

    %{data: data}
  end

  describe "update/2" do
    test "returns unchanged data if time_zones: :all", %{data: data} do
      assert DataConfig.update_time_zones(data, :all) == {:ok, data}
    end

    test "returns an error for an invalid time zone", %{data: data} do
      time_zones = ["Europe/London", "Indian", "America/Indiana", "Foo"]

      assert DataConfig.update_time_zones(data, time_zones) ==
               {:error, {:time_zones_not_found, ["Foo"]}}
    end

    test "returns time zones for configured link", %{data: data} do
      time_zones = ["Europe/Jersey"]
      assert {:ok, data} = DataConfig.update_time_zones(data, time_zones)
      assert Map.keys(data.time_zones) == ["Europe/London"]
      assert Map.keys(data.rules) == ["EU"]

      assert Map.keys(data.links) == [
               "Europe/Guernsey",
               "Europe/Isle_of_Man",
               "Europe/Jersey"
             ]
    end

    test "returns configured time zones", %{data: data} do
      time_zones = ["Europe/London", "Indian", "America/Indiana"]
      assert {:ok, data} = DataConfig.update_time_zones(data, time_zones)

      assert Map.keys(data.time_zones) == [
               "America/Indiana/Indianapolis",
               "America/Indiana/Knox",
               "America/Indiana/Marengo",
               "America/Indiana/Petersburg",
               "America/Indiana/Tell_City",
               "America/Indiana/Vevay",
               "America/Indiana/Vincennes",
               "America/Indiana/Winamac",
               "Europe/London",
               "Indian/Chagos",
               "Indian/Christmas",
               "Indian/Cocos",
               "Indian/Kerguelen",
               "Indian/Mahe",
               "Indian/Maldives",
               "Indian/Mauritius",
               "Indian/Reunion"
             ]

      assert Map.keys(data.rules) == ["EU", "US"]

      assert Map.keys(data.links) == [
               "Europe/Guernsey",
               "Europe/Isle_of_Man",
               "Europe/Jersey"
             ]
    end
  end
end
