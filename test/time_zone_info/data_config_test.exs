defmodule TimeZoneInfo.DataConfigTest do
  use ExUnit.Case

  alias TimeZoneInfo.{
    ExternalTermFormat,
    DataConfig
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
      assert DataConfig.update(data, time_zones: :all) == {:ok, data}
    end

    test "returns an error for an invalid time zone", %{data: data} do
      time_zones = ["Europe/London", "Indian", "America/Indiana", "Foo"]

      assert DataConfig.update(data, time_zones: time_zones) ==
               {:error, {:time_zones_not_found, ["Foo"]}}
    end

    test "returns configured time zones", %{data: data} do
      time_zones = ["Europe/London", "Indian", "America/Indiana"]
      assert {:ok, data} = DataConfig.update(data, time_zones: time_zones)

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
