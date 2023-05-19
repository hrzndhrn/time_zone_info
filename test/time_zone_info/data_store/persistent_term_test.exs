defmodule TimeZoneInfo.DataStore.PersistentTermTest do
  if function_exported?(:persistent_term, :get, 0) do
    use TimeZoneInfo.TimeZoneDatabaseCase,
      data_store: TimeZoneInfo.DataStore.PersistentTerm

    alias TimeZoneInfo.DataStore

    test "get_transitions/1" do
      assert {:ok, zone_states} = DataStore.get_transitions("Pacific/Auckland")

      expected = [
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

      assert Enum.take(zone_states, 3) == expected
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

    test "info/0" do
      assert %{
               count: 623,
               links: 205,
               memory: memory,
               time_zones: 387,
               version: "2019c"
             } = DataStore.info()

      # The memory size depends on the OTP version
      assert memory in [8_320_424, 8_891_831]
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
end
