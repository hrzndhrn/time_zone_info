defmodule TimeZoneInfoTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{
    DataPersistence.Priv,
    DataStore,
    DataStore.Server,
    IanaParser,
    Transformer
  }

  setup_all do
    put_env(
      data_store: Server,
      data_persistence: Priv,
      priv: [path: "data.etf"]
    )

    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    with {:ok, data} <- IanaParser.parse(path, files) do
      data
      |> Transformer.transform("2019c", lookahead: 10)
      |> DataStore.put()
    end

    on_exit(&delete_env/0)

    :ok
  end

  test "time_zones/0 returns all time zones" do
    time_zones = TimeZoneInfo.time_zones()
    assert length(time_zones) == 473
    assert Enum.member?(time_zones, "Africa/Abidjan")
    assert Enum.member?(time_zones, "Antarctica/Casey")
    assert Enum.member?(time_zones, "Pacific/Apia")
    assert Enum.member?(time_zones, "WET")
  end

  test "time_zones/1 returns time zones" do
    time_zones = TimeZoneInfo.time_zones()
    links_ignore = TimeZoneInfo.time_zones(links: :ignore)
    links_only = TimeZoneInfo.time_zones(links: :only)
    links_include = TimeZoneInfo.time_zones(links: :include)

    assert time_zones == links_include
    assert time_zones == links_only |> Enum.concat(links_ignore) |> Enum.sort()
  end

  test "iana_version/0" do
    assert TimeZoneInfo.iana_version() == "2019c"
  end

  describe "data/2" do
    test "tzdata2019c" do
      iana = "test/fixtures/iana/tzdata2019c.tar.gz"

      assert {
               :ok,
               %{links: links, rules: rules, time_zones: time_zones, version: version},
               checksum
             } = iana |> File.read!() |> TimeZoneInfo.data()

      assert version == "2019c"
      assert checksum == "BCCDD4C110F37C0DD9FB1CE732A42C10"
      assert map_size(links) == 86
      assert map_size(rules) == 29
      assert map_size(time_zones) == 387
      refute time_zones |> Map.keys() |> Enum.member?("America/Nuuk")
    end

    test "tzdata2020a" do
      iana = "test/fixtures/iana/tzdata2020a.tar.gz"

      assert {
               :ok,
               %{links: links, rules: rules, time_zones: time_zones, version: version},
               checksum
             } = iana |> File.read!() |> TimeZoneInfo.data()

      assert version == "2020a"
      assert checksum == "B3CC9137D5E6C155A38294B59755F587"
      assert map_size(links) == 86
      assert map_size(rules) == 29
      assert map_size(time_zones) == 387
      assert time_zones |> Map.keys() |> Enum.member?("America/Nuuk")
    end
  end
end
