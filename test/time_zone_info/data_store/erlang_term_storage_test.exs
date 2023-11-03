defmodule TimeZoneInfo.DataStore.ErlangTermStorageTest do
  use TimeZoneInfo.TimeZoneDatabaseCase,
    data_store: TimeZoneInfo.DataStore.ErlangTermStorage

  alias TimeZoneInfo.DataStore

  test "fetch_transitions/1" do
    assert {:ok, zone_states} = DataStore.fetch_transitions("Pacific/Auckland")

    assert Enum.take(zone_states, 3) == [
             {
               64_241_906_400,
               {43200, "NZ", {:template, "NZ%sT"}}
             },
             {
               64_226_181_600,
               {43200, 0, "NZST", {~N[2035-04-01 02:00:00], ~N[2035-09-30 02:00:00]}}
             },
             {
               64_209_852_000,
               {43200, 3600, "NZDT", {~N[2034-09-24 03:00:00], ~N[2035-04-01 03:00:00]}}
             }
           ]
  end

  test "get_rules/1" do
    assert {:ok, rules} = DataStore.get_rules("NZ")

    assert rules == [
             {{4, [day: 1, op: :ge, day_of_week: 7], {2, 0, 0}}, :standard, 0, "S"},
             {{9, [last_day_of_week: 7], {2, 0, 0}}, :standard, 3600, "D"}
           ]
  end

  test "get_time_zones/1 returns time zones" do
    time_zones = TimeZoneInfo.time_zones()
    links_ignore = TimeZoneInfo.time_zones(links: :ignore)
    links_only = TimeZoneInfo.time_zones(links: :only)
    links_include = TimeZoneInfo.time_zones(links: :include)

    assert time_zones == links_include
    assert time_zones == links_only |> Enum.concat(links_ignore) |> Enum.sort()
  end

  test "version/0" do
    assert DataStore.version() == "2019c"
  end

  test "empty?" do
    assert DataStore.empty?() == false
  end

  test "info" do
    assert %{version: version, time_zones: time_zones, links: links, tables: tables} =
             DataStore.info()

    assert version == "2019c"
    assert time_zones == 387
    assert links == 205
    assert get_in(tables, [:time_zone_info, :size]) == 1
    assert get_in(tables, [:time_zone_info, :memory]) > 300
    assert get_in(tables, [:time_zone_info_links, :size]) == 205
    assert get_in(tables, [:time_zone_info_links, :memory]) > 1600
    assert get_in(tables, [:time_zone_info_rules, :size]) == 29
    assert get_in(tables, [:time_zone_info_rules, :memory]) > 2100
    assert get_in(tables, [:time_zone_info_time_zones, :size]) == 3
    assert get_in(tables, [:time_zone_info_time_zones, :memory]) > 6200
    assert get_in(tables, [:time_zone_info_transitions, :size]) == 387
    assert get_in(tables, [:time_zone_info_transitions, :memory]) > 323_000
  end

  describe "time_zone_period_from_utc_iso_days/2" do
    prove "returns an error tuple for",
          time_zone_period_from_utc_iso_days(
            ~N[2012-03-25 01:59:59],
            "Utopia/Foo"
          ) == {:error, :time_zone_not_found}

    prove "follows a link",
          time_zone_period_from_utc_iso_days(
            ~N[2012-03-25 01:59:59],
            "Africa/Freetown"
          ) == {
            :ok,
            %{
              std_offset: 0,
              utc_offset: 0,
              zone_abbr: "GMT",
              wall_period: {~N[1912-01-01 00:16:08], :max}
            }
          }
  end

  describe "time_zone_periods_from_wall_datetime/2" do
    prove "returns an error tuple for",
          time_zone_periods_from_wall_datetime(
            ~N[2012-03-25 01:59:59],
            "Utopia/Foo"
          ) == {:error, :time_zone_not_found}

    prove "follows a link",
          time_zone_periods_from_wall_datetime(
            ~N[2012-03-25 01:59:59],
            "Africa/Freetown"
          ) == {
            :ok,
            %{
              std_offset: 0,
              utc_offset: 0,
              zone_abbr: "GMT",
              wall_period: {~N[1912-01-01 00:16:08], :max}
            }
          }
  end

  describe "time_zone_period_from_utc_iso_days/2 per decade/century:" do
    property_time_zone_period_from_utc_iso_days(
      from: ~N[2010-01-01 00:00:00],
      to: ~N[2020-01-01 00:00:00]
    )

    property_time_zone_period_from_utc_iso_days(
      from: ~N[2000-01-01 00:00:00],
      to: ~N[2010-01-01 00:00:00]
    )

    property_time_zone_period_from_utc_iso_days(
      from: ~N[1900-01-01 00:00:00],
      to: ~N[2000-01-01 00:00:00]
    )

    property_time_zone_period_from_utc_iso_days(
      from: ~N[1800-01-01 00:00:00],
      to: ~N[1900-01-01 00:00:00]
    )
  end

  describe "time_zone_periods_from_wall_datetime/2 per decade/century:" do
    property_time_zone_periods_from_wall_datetime(
      from: ~N[2010-01-01 00:00:00],
      to: ~N[2020-01-01 00:00:00]
    )

    property_time_zone_periods_from_wall_datetime(
      from: ~N[2000-01-01 00:00:00],
      to: ~N[2010-01-01 00:00:00]
    )

    property_time_zone_periods_from_wall_datetime(
      from: ~N[1900-01-01 00:00:00],
      to: ~N[2000-01-01 00:00:00]
    )

    property_time_zone_periods_from_wall_datetime(
      from: ~N[1800-01-01 00:00:00],
      to: ~N[1900-01-01 00:00:00]
    )
  end
end
