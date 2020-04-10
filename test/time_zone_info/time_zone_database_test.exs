defmodule TimeZoneInfo.TimeZoneDatabaseTest do
  use TimeZoneInfo.TimeZoneDatabaseCase

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
          ) == {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "GMT"}}

    prove "for zone_state.format choice",
          time_zone_period_from_utc_iso_days(
            ~N[2012-09-01 12:00:00],
            "Europe/London"
          ) == {:ok, %{std_offset: 3600, utc_offset: 0, zone_abbr: "BST"}}

    prove "for zone_state.format choice and letters in choice",
          time_zone_period_from_utc_iso_days(
            ~N[1960-12-05 01:28:14],
            "Europe/Dublin"
          ) == {:ok, %{utc_offset: 0, zone_abbr: "GMT", std_offset: 0}}

    prove "before zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[2011-03-26 23:59:59],
            "Europe/Kaliningrad"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}}

    prove "when zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[2011-03-27 00:00:00],
            "Europe/Kaliningrad"
          ) == {:ok, %{std_offset: 0, utc_offset: 10800, zone_abbr: "+03"}}

    prove "on zone-state last active moment",
          time_zone_period_from_utc_iso_days(
            ~N[2014-10-25 22:59:59],
            "Europe/Kaliningrad"
          ) == {:ok, %{std_offset: 0, utc_offset: 10800, zone_abbr: "+03"}}

    prove "after zone-state was active",
          time_zone_period_from_utc_iso_days(
            ~N[2014-10-25 23:00:00],
            "Europe/Kaliningrad"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}}

    # test a zone-state with time-standard wall and next zone-state has a
    # std-offset in rules
    prove "before zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[1931-07-23 22:15:35],
            "Europe/Chisinau"
          ) == {:ok, %{std_offset: 0, utc_offset: 6264, zone_abbr: "BMT"}}

    prove "when zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[1931-07-23 22:15:36],
            "Europe/Chisinau"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}}

    prove "on zone-state last active moment",
          time_zone_period_from_utc_iso_days(
            ~N[1940-08-14 21:59:59],
            "Europe/Chisinau"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}}

    prove "after zone-state was active",
          time_zone_period_from_utc_iso_days(
            ~N[1940-08-14 22:00:00],
            "Europe/Chisinau"
          ) == {:ok, %{utc_offset: 7200, std_offset: 3600, zone_abbr: "EEST"}}

    # test a zone-state with time-standard wall and a std-offset
    prove "before zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[1981-12-23 05:59:59],
            "America/Cancun"
          ) == {:ok, %{std_offset: 0, utc_offset: -21600, zone_abbr: "CST"}}

    prove "when zone-state becomes active",
          time_zone_period_from_utc_iso_days(
            ~N[1981-12-23 06:00:00],
            "America/Cancun"
          ) == {:ok, %{std_offset: 0, utc_offset: -18000, zone_abbr: "EST"}}

    prove "on zone-states last active moment",
          time_zone_period_from_utc_iso_days(
            ~N[1998-08-02 05:59:59],
            "America/Cancun"
          ) == {:ok, %{std_offset: 3600, utc_offset: -18000, zone_abbr: "EDT"}}

    prove "after zone-state was active",
          time_zone_period_from_utc_iso_days(
            ~N[1998-08-02 06:00:00],
            "America/Cancun"
          ) == {:ok, %{std_offset: 3600, utc_offset: -21600, zone_abbr: "CDT"}}

    prove time_zone_period_from_utc_iso_days(
            ~N[2000-10-28 02:00:00],
            "Etc/GMT-2"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "+02"}}

    desc = "Calculate period from rules"

    prove desc,
          time_zone_period_from_utc_iso_days(
            ~N[2034-03-26 01:00:00],
            "Europe/Berlin"
          ) == {:ok, %{std_offset: 3600, utc_offset: 3600, zone_abbr: "CEST"}}

    prove desc,
          time_zone_period_from_utc_iso_days(
            ~N[2034-03-26 00:59:59],
            "Europe/Berlin"
          ) == {:ok, %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}}

    prove desc,
          time_zone_period_from_utc_iso_days(
            ~N[2034-01-01 00:59:59],
            "Europe/Berlin"
          ) == {:ok, %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}}

    prove desc,
          time_zone_period_from_utc_iso_days(
            ~N[2043-04-03 08:20:08],
            "Pacific/Chatham"
          ) == {:ok, %{std_offset: 3600, utc_offset: 45900, zone_abbr: "+1345"}}

    # ==========================================================================
    # Additional tests, , for some bugs I can't remember.

    prove time_zone_period_from_utc_iso_days(
            ~N[1998-08-02 06:00:00],
            "Europe/Istanbul"
          ) == {:ok, %{std_offset: 3600, utc_offset: 7200, zone_abbr: "EEST"}}

    prove time_zone_period_from_utc_iso_days(
            ~N[2025-12-20 15:00:00],
            "Pacific/Chatham"
          ) == {:ok, %{std_offset: 3600, utc_offset: 45900, zone_abbr: "+1345"}}

    prove time_zone_period_from_utc_iso_days(
            ~N[1991-03-30 21:00:00],
            "Asia/Yekaterinburg"
          ) == {:ok, %{std_offset: 3600, utc_offset: 14400, zone_abbr: "+05"}}

    prove time_zone_period_from_utc_iso_days(
            ~N[1991-03-30 20:59:59],
            "Asia/Yekaterinburg"
          ) == {:ok, %{std_offset: 0, utc_offset: 18000, zone_abbr: "+05"}}

    prove time_zone_period_from_utc_iso_days(
            ~N[1994-09-24 22:00:00],
            "Asia/Aqtau"
          ) == {
            :ok,
            %{
              std_offset: 0,
              utc_offset: 14400,
              zone_abbr: "+04"
            }
          }

    prove time_zone_period_from_utc_iso_days(
            ~N[1996-02-07 22:15:45],
            "Europe/London"
          ) == {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "GMT"}}
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

  describe "time_zone_period_from_utc_iso_days/2 around the world:" do
    # UTC-11
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Niue")
    # UTC-10
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Honolulu")
    # UTC-09
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Marquesas")
    # UTC-08
    property_time_zone_period_from_utc_iso_days(time_zone: "America/Los_Angeles")
    # UTC-07
    property_time_zone_period_from_utc_iso_days(time_zone: "America/Chihuahua")
    # UTC-06
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Galapagos")
    # UTC-05
    property_time_zone_period_from_utc_iso_days(time_zone: "America/Nassau")
    # UTC-04
    property_time_zone_period_from_utc_iso_days(time_zone: "America/Manaus")
    # UTC-03
    property_time_zone_period_from_utc_iso_days(time_zone: "America/Sao_Paulo")
    # UTC-02
    property_time_zone_period_from_utc_iso_days(time_zone: "Etc/GMT-2")
    # UTC-01
    property_time_zone_period_from_utc_iso_days(time_zone: "Atlantic/Cape_Verde")
    # UTC+00
    property_time_zone_period_from_utc_iso_days(time_zone: "Europe/London")
    # test the negative offset
    property_time_zone_period_from_utc_iso_days(time_zone: "Europe/Dublin")
    # UTC+01
    property_time_zone_period_from_utc_iso_days(time_zone: "Europe/Berlin")
    # UTC+02
    property_time_zone_period_from_utc_iso_days(time_zone: "Europe/Helsinki")
    # UTC+03
    property_time_zone_period_from_utc_iso_days(time_zone: "Africa/Juba")
    # UTC+04
    property_time_zone_period_from_utc_iso_days(time_zone: "Indian/Mahe")
    # UTC+05
    property_time_zone_period_from_utc_iso_days(time_zone: "Asia/Yekaterinburg")
    # UTC+06
    property_time_zone_period_from_utc_iso_days(time_zone: "Asia/Thimphu")
    # UTC+07
    property_time_zone_period_from_utc_iso_days(time_zone: "Asia/Jakarta")
    # UTC+08
    property_time_zone_period_from_utc_iso_days(time_zone: "Australia/Perth")
    # UTC+09
    property_time_zone_period_from_utc_iso_days(time_zone: "Asia/Tokyo")
    # UTC+10
    property_time_zone_period_from_utc_iso_days(time_zone: "Australia/Brisbane")
    # UTC+11
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Guadalcanal")
    # UTC+12
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Chatham")
    # UTC+13
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Fakaofo")
    # UTC+14
    property_time_zone_period_from_utc_iso_days(time_zone: "Pacific/Kiritimati")
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
          ) == {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "GMT"}}

    # ==========================================================================
    # America/Adak
    # 1983-04-24 13:00:00Z -10:00:00 daylight BDT
    # 1983-10-30 12:00:00Z -10:00:00 standard AHST
    # 1983-11-30 10:00:00Z -10:00:00 standard HST

    desc = "just a zone abbr change in"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1983-10-30 01:59:59],
            "America/Adak"
          ) == {:ok, %{std_offset: 3600, utc_offset: -39600, zone_abbr: "BDT"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1983-10-30 02:59:59],
            "America/Adak"
          ) == {:ok, %{std_offset: 0, utc_offset: -36000, zone_abbr: "AHST"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1983-11-30 00:00:00],
            "America/Adak"
          ) == {:ok, %{std_offset: 0, utc_offset: -36000, zone_abbr: "HST"}}

    # ==========================================================================
    desc = ":ok, :gap, and :ambiguous in"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2012-03-25 01:59:59],
            "Europe/Berlin"
          ) == {:ok, %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2012-03-25 02:00:00],
            "Europe/Berlin"
          ) ==
            {
              :gap,
              {%{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}, ~N[2012-03-25 02:00:00]},
              {%{std_offset: 3600, utc_offset: 3600, zone_abbr: "CEST"}, ~N[2012-03-25 03:00:00]}
            }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2012-10-28 02:00:00],
            "Europe/Berlin"
          ) ==
            {
              :ambiguous,
              %{std_offset: 3600, utc_offset: 3600, zone_abbr: "CEST"},
              %{std_offset: 0, utc_offset: 3600, zone_abbr: "CET"}
            }

    # ==========================================================================

    prove time_zone_periods_from_wall_datetime(
            ~N[2000-10-28 02:00:00],
            "Etc/GMT-2"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "+02"}}

    # ==========================================================================

    prove time_zone_periods_from_wall_datetime(
            ~N[2021-10-18 00:26:23],
            "America/Chihuahua"
          ) == {:ok, %{std_offset: 3600, utc_offset: -25200, zone_abbr: "MDT"}}

    prove time_zone_periods_from_wall_datetime(
            ~N[1977-10-20 22:40:49],
            "Africa/Algiers"
          ) == {:ok, %{std_offset: 3600, utc_offset: 0, zone_abbr: "WEST"}}

    prove time_zone_periods_from_wall_datetime(
            ~N[1997-03-29 22:01:09],
            "Asia/Tbilisi"
          ) == {:ok, %{std_offset: 3600, utc_offset: 14400, zone_abbr: "+05"}}

    # ==========================================================================
    # America/Winnipeg
    # 1999-10-31 08:00:00Z -06:00:00 standard CST
    # 2000-04-02 08:00:00Z -05:00:00 daylight CDT
    # 2000-10-29 08:00:00Z -06:00:00 standard CST
    # 2001-04-01 08:00:00Z -05:00:00 daylight CDT

    # Asia/Novosibirsk
    # 1999-10-30 20:00:00Z +06:00:00 standard +06
    # 2000-03-25 20:00:00Z +07:00:00 daylight +07
    # 2000-10-28 20:00:00Z +06:00:00 standard +06
    # 2001-03-24 20:00:00Z +07:00:00 daylight +07

    # Europe/Dublin
    # 1999-10-31 01:00:00Z +00:00:00 daylight GMT
    # 2000-03-26 01:00:00Z +01:00:00 standard IST
    # 2000-10-29 01:00:00Z +00:00:00 daylight GMT
    # 2001-03-25 01:00:00Z +01:00:00 standard IS

    # --------------------------------------------------------------------------
    desc = "before a gap"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-04-02 01:59:59],
            "America/Winnipeg"
          ) == {:ok, %{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 01:59:59],
            "Asia/Novosibirsk"
          ) == {:ok, %{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 00:59:59],
            "Europe/Dublin"
          ) == {:ok, %{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}}

    # --------------------------------------------------------------------------
    desc = "at the start of a gap"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-04-02 02:00:00],
            "America/Winnipeg"
          ) == {
            :gap,
            {%{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}, ~N[2000-04-02 02:00:00]},
            {%{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"}, ~N[2000-04-02 03:00:00]}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 02:00:00],
            "Asia/Novosibirsk"
          ) == {
            :gap,
            {%{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}, ~N[2000-03-26 02:00:00]},
            {%{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"}, ~N[2000-03-26 03:00:00]}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 01:00:00],
            "Europe/Dublin"
          ) == {
            :gap,
            {%{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}, ~N[2000-03-26 01:00:00]},
            {%{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"}, ~N[2000-03-26 02:00:00]}
          }

    # --------------------------------------------------------------------------
    desc = "at the end of a gap"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-04-02 02:59:59],
            "America/Winnipeg"
          ) == {
            :gap,
            {%{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}, ~N[2000-04-02 02:00:00]},
            {%{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"}, ~N[2000-04-02 03:00:00]}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 02:59:59],
            "Asia/Novosibirsk"
          ) == {
            :gap,
            {%{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}, ~N[2000-03-26 02:00:00]},
            {%{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"}, ~N[2000-03-26 03:00:00]}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 01:59:59],
            "Europe/Dublin"
          ) == {
            :gap,
            {%{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}, ~N[2000-03-26 01:00:00]},
            {%{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"}, ~N[2000-03-26 02:00:00]}
          }

    # --------------------------------------------------------------------------
    desc = "after a gap"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-04-02 03:00:00],
            "America/Winnipeg"
          ) == {:ok, %{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 03:00:00],
            "Asia/Novosibirsk"
          ) == {:ok, %{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-03-26 02:00:00],
            "Europe/Dublin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"}}

    # --------------------------------------------------------------------------
    desc = "before an ambiguous time span"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 01:59:59],
            "America/Winnipeg"
          ) == {:ok, %{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 01:59:59],
            "Asia/Novosibirsk"
          ) == {:ok, %{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 00:59:59],
            "Europe/Dublin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"}}

    # --------------------------------------------------------------------------
    desc = "at the start of an ambiguous time span"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 02:00:00],
            "America/Winnipeg"
          ) ==
            {
              :ambiguous,
              %{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"},
              %{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}
            }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 02:00:00],
            "Asia/Novosibirsk"
          ) ==
            {
              :ambiguous,
              %{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"},
              %{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}
            }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 01:00:00],
            "Europe/Dublin"
          ) ==
            {
              :ambiguous,
              %{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"},
              %{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}
            }

    # --------------------------------------------------------------------------
    desc = "at the end of an ambiguous time span"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 02:59:59],
            "America/Winnipeg"
          ) ==
            {
              :ambiguous,
              %{utc_offset: -21600, std_offset: 3600, zone_abbr: "CDT"},
              %{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}
            }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 02:59:59],
            "Asia/Novosibirsk"
          ) ==
            {
              :ambiguous,
              %{utc_offset: 21600, std_offset: 3600, zone_abbr: "+07"},
              %{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}
            }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 01:59:59],
            "Europe/Dublin"
          ) ==
            {
              :ambiguous,
              %{utc_offset: 3600, std_offset: 0, zone_abbr: "IST"},
              %{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}
            }

    # --------------------------------------------------------------------------
    desc = "after an ambiguous time span"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 03:00:00],
            "America/Winnipeg"
          ) == {:ok, %{utc_offset: -21600, std_offset: 0, zone_abbr: "CST"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 03:00:00],
            "Asia/Novosibirsk"
          ) == {:ok, %{utc_offset: 21600, std_offset: 0, zone_abbr: "+06"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[2000-10-29 02:00:00],
            "Europe/Dublin"
          ) == {:ok, %{utc_offset: 3600, std_offset: -3600, zone_abbr: "GMT"}}

    # ==========================================================================

    # Asia/Riyadh
    # Initially:           +03:06:52 standard LMT
    # 1947-03-13 20:53:08Z +03:00:00 standard +03

    # Asia/Dubai
    # Initially:           +03:41:12 standard LMT
    # 1919-12-31 20:18:48Z +04:00:00 standard +04

    # --------------------------------------------------------------------------
    desc = "before any time zone"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1947-03-13 23:53:07],
            "Asia/Riyadh"
          ) == {:ok, %{utc_offset: 11212, std_offset: 0, zone_abbr: "LMT"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1919-12-31 23:59:59],
            "Asia/Dubai"
          ) == {:ok, %{utc_offset: 13272, std_offset: 0, zone_abbr: "LMT"}}

    # --------------------------------------------------------------------------
    desc = "in first transition"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1947-03-13 23:53:08],
            "Asia/Riyadh"
          ) == {
            :ambiguous,
            %{utc_offset: 11212, std_offset: 0, zone_abbr: "LMT"},
            %{utc_offset: 10800, std_offset: 0, zone_abbr: "+03"}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1920-01-01 00:00:00],
            "Asia/Dubai"
          ) == {
            :gap,
            {%{utc_offset: 13272, std_offset: 0, zone_abbr: "LMT"}, ~N[1920-01-01 00:00:00]},
            {%{utc_offset: 14400, std_offset: 0, zone_abbr: "+04"}, ~N[1920-01-01 00:18:48]}
          }

    # --------------------------------------------------------------------------
    desc = "at the end of first transition"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1947-03-13 23:59:59],
            "Asia/Riyadh"
          ) == {
            :ambiguous,
            %{utc_offset: 11212, std_offset: 0, zone_abbr: "LMT"},
            %{utc_offset: 10800, std_offset: 0, zone_abbr: "+03"}
          }

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1920-01-01 00:18:47],
            "Asia/Dubai"
          ) == {
            :gap,
            {%{utc_offset: 13272, std_offset: 0, zone_abbr: "LMT"}, ~N[1920-01-01 00:00:00]},
            {%{utc_offset: 14400, std_offset: 0, zone_abbr: "+04"}, ~N[1920-01-01 00:18:48]}
          }

    # --------------------------------------------------------------------------
    desc = "after the first transition"

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1947-03-14 00:00:00],
            "Asia/Riyadh"
          ) == {:ok, %{utc_offset: 10800, std_offset: 0, zone_abbr: "+03"}}

    prove desc,
          time_zone_periods_from_wall_datetime(
            ~N[1920-01-01 00:18:48],
            "Asia/Dubai"
          ) == {:ok, %{utc_offset: 14400, std_offset: 0, zone_abbr: "+04"}}

    # ==========================================================================
    # Periods in the future will be calculate on the fly.

    prove "at the start of an ambiguous time span in the future (last without cal.)",
          time_zone_periods_from_wall_datetime(
            ~N[2039-10-30 02:00:00],
            "Europe/Berlin"
          ) == {
            :ambiguous,
            %{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"},
            %{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}
          }

    prove "before an ambiguous time span in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2040-10-28 01:59:59],
            "Europe/Berlin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"}}

    prove "at the start of an ambiguous time span in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2040-10-28 02:00:00],
            "Europe/Berlin"
          ) == {
            :ambiguous,
            %{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"},
            %{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}
          }

    prove "at the end of an ambiguous time span in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2040-10-28 02:59:59],
            "Europe/Berlin"
          ) == {
            :ambiguous,
            %{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"},
            %{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}
          }

    prove "after an ambiguous time span in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2040-10-28 03:00:00],
            "Europe/Berlin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}}

    prove "before a gap in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-31 01:59:59],
            "Europe/Berlin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}}

    prove "at the start of a gap in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-31 02:00:00],
            "Europe/Berlin"
          ) == {
            :gap,
            {%{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}, ~N[2041-03-31 02:00:00]},
            {%{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"}, ~N[2041-03-31 03:00:00]}
          }

    prove "at the end of a gap in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-31 02:59:59],
            "Europe/Berlin"
          ) == {
            :gap,
            {%{utc_offset: 3600, std_offset: 0, zone_abbr: "CET"}, ~N[2041-03-31 02:00:00]},
            {%{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"}, ~N[2041-03-31 03:00:00]}
          }

    prove "after a gap in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-31 03:00:00],
            "Europe/Berlin"
          ) == {:ok, %{utc_offset: 3600, std_offset: 3600, zone_abbr: "CEST"}}

    # time zone with time-standard wall rule

    prove "in the future",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-31 03:00:00],
            "America/Merida"
          ) == {:ok, %{std_offset: 0, utc_offset: -21600, zone_abbr: "CST"}}

    prove "in the future with a gap",
          time_zone_periods_from_wall_datetime(
            ~N[2041-04-07 02:10:00],
            "America/Merida"
          ) == {
            :gap,
            {%{std_offset: 0, utc_offset: -21600, zone_abbr: "CST"}, ~N[2041-04-07 02:00:00]},
            {%{std_offset: 3600, utc_offset: -21600, zone_abbr: "CDT"}, ~N[2041-04-07 03:00:00]}
          }

    # time zone with time-standard wall and standard rule

    prove "in the future before a gap",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-28 23:59:59],
            "Asia/Amman"
          ) == {:ok, %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}}

    prove "in the future in a gap",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-29 00:10:59],
            "Asia/Amman"
          ) == {
            :gap,
            {%{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}, ~N[2041-03-29 00:00:00]},
            {%{std_offset: 3600, utc_offset: 7200, zone_abbr: "EEST"}, ~N[2041-03-29 01:00:00]}
          }

    prove "in the future after a gap",
          time_zone_periods_from_wall_datetime(
            ~N[2041-03-29 01:00:00],
            "Asia/Amman"
          ) == {:ok, %{std_offset: 3600, utc_offset: 7200, zone_abbr: "EEST"}}

    @tag :only
    prove "in the future in an ambiguous time span",
          time_zone_periods_from_wall_datetime(
            ~N[2041-10-25 00:30:00],
            "Asia/Amman"
          ) == {
            :ambiguous,
            %{std_offset: 3600, utc_offset: 7200, zone_abbr: "EEST"},
            %{std_offset: 0, utc_offset: 7200, zone_abbr: "EET"}
          }

    # ==========================================================================

    prove "with a negative datetime",
          time_zone_periods_from_wall_datetime(
            ~N[-1111-03-31 03:00:00],
            "Europe/Berlin"
          ) == {:ok, %{utc_offset: 3208, std_offset: 0, zone_abbr: "LMT"}}

    # ==========================================================================
    # Issue: https://github.com/hrzndhrn/time_zone_info/issues/4

    prove time_zone_periods_from_wall_datetime(
            ~N[1994-09-24 22:00:00],
            "Asia/Aqtau"
          ) == {
            :ok,
            %{
              std_offset: 3600,
              utc_offset: 18000,
              zone_abbr: "+06"
            }
          }

    # ==========================================================================

    prove time_zone_periods_from_wall_datetime(
            ~N[2006-04-13 06:58:29],
            "America/Indiana/Winamac"
          ) == {:ok, %{std_offset: 3600, utc_offset: -21600, zone_abbr: "CDT"}}

    prove time_zone_periods_from_wall_datetime(
            ~N[1942-06-22 09:10:49],
            "America/Montevideo"
          ) == {:ok, %{std_offset: 1800, utc_offset: -12600, zone_abbr: "-03"}}

    prove time_zone_periods_from_wall_datetime(
            ~N[1980-06-29 20:55:51],
            "America/Godthab"
          ) == {:ok, %{std_offset: 3600, utc_offset: -10800, zone_abbr: "-02"}}
  end

  describe "time_zone_periods_from_wall_datetime/2 in the transition month:" do
    property_time_zone_periods_from_wall_datetime(
      from: ~N[2010-03-21 00:00:00],
      to: ~N[2010-04-01 00:00:00]
    )

    property_time_zone_periods_from_wall_datetime(
      from: ~N[2010-10-21 00:00:00],
      to: ~N[2010-11-01 00:00:00]
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

  describe "time_zone_periods_from_wall_datetime/2 around the world:" do
    # UTC-11
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Niue")
    # UTC-10
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Honolulu")
    # UTC-09
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Marquesas")
    # UTC-08
    property_time_zone_periods_from_wall_datetime(time_zone: "America/Los_Angeles")
    # UTC-07
    property_time_zone_periods_from_wall_datetime(time_zone: "America/Chihuahua")
    # UTC-06
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Galapagos")
    # UTC-05
    property_time_zone_periods_from_wall_datetime(time_zone: "America/Nassau")
    # UTC-04
    property_time_zone_periods_from_wall_datetime(time_zone: "America/Manaus")
    # UTC-03
    property_time_zone_periods_from_wall_datetime(time_zone: "America/Sao_Paulo")
    # UTC-02
    property_time_zone_periods_from_wall_datetime(time_zone: "Etc/GMT-2")
    # UTC-01
    property_time_zone_periods_from_wall_datetime(time_zone: "Atlantic/Cape_Verde")
    # UTC+00
    property_time_zone_periods_from_wall_datetime(time_zone: "Europe/London")
    # test the negative offset
    property_time_zone_periods_from_wall_datetime(time_zone: "Europe/Dublin")
    # UTC+01
    property_time_zone_periods_from_wall_datetime(time_zone: "Europe/Berlin")
    # UTC+02
    property_time_zone_periods_from_wall_datetime(time_zone: "Europe/Helsinki")
    # UTC+03
    property_time_zone_periods_from_wall_datetime(time_zone: "Africa/Juba")
    # UTC+04
    property_time_zone_periods_from_wall_datetime(time_zone: "Indian/Mahe")
    # UTC+05
    property_time_zone_periods_from_wall_datetime(time_zone: "Asia/Yekaterinburg")
    # UTC+06
    property_time_zone_periods_from_wall_datetime(time_zone: "Asia/Thimphu")
    # UTC+07
    property_time_zone_periods_from_wall_datetime(time_zone: "Asia/Jakarta")
    # UTC+08
    property_time_zone_periods_from_wall_datetime(time_zone: "Australia/Perth")
    # UTC+09
    property_time_zone_periods_from_wall_datetime(time_zone: "Asia/Tokyo")
    # UTC+10
    property_time_zone_periods_from_wall_datetime(time_zone: "Australia/Brisbane")
    # UTC+11
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Guadalcanal")
    # UTC+12
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Chatham")
    # UTC+13
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Fakaofo")
    # UTC+14
    property_time_zone_periods_from_wall_datetime(time_zone: "Pacific/Kiritimati")
  end
end
