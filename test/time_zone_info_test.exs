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

    path = "test/temp/iana"

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

  test "zone_abbr parameter" do
    ndt = ~N"2015-01-13 19:00:07"
    dt = DateTime.from_naive!(ndt, "Etc/UTC")
    dt = DateTime.shift_zone!(dt, "Etc/GMT+12", TimeZoneInfo.TimeZoneDatabase)
    assert dt.zone_abbr == "-12"
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
      assert checksum == "43742063"
      assert map_size(links) == 86
      assert map_size(rules) == 29
      assert map_size(time_zones) == 387
      refute time_zones |> Map.keys() |> Enum.member?("America/Nuuk")
    end

    test "tzdata2024b" do
      iana = "test/fixtures/iana/tzdata2024b.tar.gz"

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
             } =
               iana
               |> File.read!()
               |> TimeZoneInfo.data(
                 lookahead: 15,
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
                 ]
               )

      assert version == "2024b"
      assert checksum == "94227132"

      assert config[:time_zones] == :all
      assert config[:lookahead] == 15

      assert config[:files] == [
               "africa",
               "antarctica",
               "asia",
               "australasia",
               "backward",
               "etcetera",
               "europe",
               "northamerica",
               "southamerica"
             ]

      assert map_size(time_zones) == 339
      assert map_size(rules) == 23
      assert map_size(links) == 257
    end
  end
end
