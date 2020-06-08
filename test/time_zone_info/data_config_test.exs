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

    @tag :only
    test "returns time zones for configured link", %{data: data} do
      time_zones = ["Europe/Jersey"]
      assert {:ok, data} = DataConfig.update_time_zones(data, time_zones)
      assert Map.keys(data.time_zones) == ["Europe/London"]
      assert Map.keys(data.rules) == ["EU"]
      assert Map.keys(data.links) == ["Europe/Jersey"]
    end

    test "returns configured time zones for africa", %{data: data} do
      time_zones = ["Africa"]
      assert {:ok, data} = DataConfig.update_time_zones(data, time_zones)

      assert data.time_zones |> Map.keys() |> Enum.sort() == [
               "Africa/Abidjan",
               "Africa/Accra",
               "Africa/Algiers",
               "Africa/Bissau",
               "Africa/Cairo",
               "Africa/Casablanca",
               "Africa/Ceuta",
               "Africa/El_Aaiun",
               "Africa/Johannesburg",
               "Africa/Juba",
               "Africa/Khartoum",
               "Africa/Lagos",
               "Africa/Maputo",
               "Africa/Monrovia",
               "Africa/Nairobi",
               "Africa/Ndjamena",
               "Africa/Sao_Tome",
               "Africa/Tripoli",
               "Africa/Tunis",
               "Africa/Windhoek"
             ]

      assert data.links |> Map.keys() |> Enum.sort() == [
               "Africa/Addis_Ababa",
               "Africa/Asmara",
               "Africa/Bamako",
               "Africa/Bangui",
               "Africa/Banjul",
               "Africa/Blantyre",
               "Africa/Brazzaville",
               "Africa/Bujumbura",
               "Africa/Conakry",
               "Africa/Dakar",
               "Africa/Dar_es_Salaam",
               "Africa/Djibouti",
               "Africa/Douala",
               "Africa/Freetown",
               "Africa/Gaborone",
               "Africa/Harare",
               "Africa/Kampala",
               "Africa/Kigali",
               "Africa/Kinshasa",
               "Africa/Libreville",
               "Africa/Lome",
               "Africa/Luanda",
               "Africa/Lubumbashi",
               "Africa/Lusaka",
               "Africa/Malabo",
               "Africa/Maseru",
               "Africa/Mbabane",
               "Africa/Mogadishu",
               "Africa/Niamey",
               "Africa/Nouakchott",
               "Africa/Ouagadougou",
               "Africa/Porto-Novo"
             ]

      assert Map.keys(data.rules) == ["EU"]
    end

    test "returns configured time zones", %{data: data} do
      time_zones = ["Europe/London", "Indian", "America/Indiana"]
      assert {:ok, data} = DataConfig.update_time_zones(data, time_zones)

      assert Map.keys(data.time_zones) == [
               "Africa/Nairobi",
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
               "Indian/Antananarivo",
               "Indian/Comoro",
               "Indian/Mayotte"
             ]
    end
  end
end
