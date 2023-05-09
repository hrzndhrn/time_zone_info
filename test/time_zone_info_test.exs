defmodule TimeZoneInfoTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.DataPersistence.Priv
  alias TimeZoneInfo.DataStore
  alias TimeZoneInfo.DataStore.Server
  alias TimeZoneInfo.IanaParser
  alias TimeZoneInfo.Transformer

  setup_all do
    put_app_env(
      data_store: Server,
      data_persistence: Priv,
      priv: [path: "data.etf"]
    )

    path = "test/fixtures/iana/2019c"

    config = [
      files: [
        "africa",
        "antarctica",
        "asia",
        "australasia",
        "etcetera",
        "europe",
        "northamerica",
        "southamerica"
      ],
      lookahead: 10,
      time_zones: :all
    ]

    with {:ok, data} <- IanaParser.parse(path, config[:files]) do
      data
      |> Transformer.transform("2019c", config)
      |> DataStore.put()
    end

    put_app_env(
      data_store: Server,
      data_persistence: Priv,
      priv: [path: "data.etf"],
      files: config[:files],
      lookahead: config[:lookahead],
      time_zones: config[:time_zones]
    )

    on_exit(&delete_app_env/0)

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
      assert checksum == "20316920"
      assert map_size(links) == 86
      assert map_size(rules) == 29
      assert map_size(time_zones) == 387
      refute time_zones |> Map.keys() |> Enum.member?("America/Nuuk")
    end

    test "tzdata2020a" do
      iana = "test/fixtures/iana/tzdata2020a.tar.gz"

      assert {
               :ok,
               %{
                 links: links,
                 rules: rules,
                 time_zones: time_zones,
                 version: version,
                 config: config
               },
               checksum
             } = iana |> File.read!() |> TimeZoneInfo.data()

      assert version == "2020a"
      assert checksum == "115196438"
      assert map_size(links) == 86
      assert map_size(rules) == 29
      assert map_size(time_zones) == 387
      assert time_zones |> Map.keys() |> Enum.member?("America/Nuuk")
      assert config[:time_zones] == :all
      assert config[:lookahead] == 10

      assert config[:files] == [
               "africa",
               "antarctica",
               "asia",
               "australasia",
               "etcetera",
               "europe",
               "northamerica",
               "southamerica"
             ]
    end

    test "tzdata2021b" do
      iana = "test/fixtures/iana/tzdata2021b.tar.gz"

      assert {
               :ok,
               %{
                 links: links,
                 rules: rules,
                 time_zones: time_zones,
                 version: version,
                 config: config
               },
               checksum
             } = iana |> File.read!() |> TimeZoneInfo.data()

      assert version == "2021b"
      assert checksum == "32624947"

      assert map_size(links) == 7
      assert map_size(rules) == 28
      assert map_size(time_zones) == 377

      assert config[:time_zones] == :all
      assert config[:lookahead] == 10

      assert config[:files] == [
               "africa",
               "antarctica",
               "asia",
               "australasia",
               "etcetera",
               "europe",
               "northamerica",
               "southamerica"
             ]
    end
  end
end
