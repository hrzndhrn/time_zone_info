defmodule TimeZoneInfo.TransformerTest do
  use ExUnit.Case, async: true

  require Logger

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil, Transformer}

  setup_all do
    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    %{data: path |> parse(files) |> Transformer.transform("2019c", lookahead: 1)}
    # %{data: :a}
  end

  describe "transform/1 extract" do
    @tag :alg
    test "returns transformed data for time zone Africa/Algiers" do
      assert_time_zone("Africa/Algiers")
    end

    @tag :ada
    test "returns transformed data for time zone America/Adak" do
      assert_time_zone("America/Adak")
    end

    @tag :can
    test "returns transformed data for time zone America/Cancun" do
      assert_time_zone("America/Cancun")
    end

    @tag :daw
    test "returns transformed data for time zone America/Dawson" do
      assert_time_zone("America/Dawson")
    end

    @tag :god
    test "returns transformed data for time zone America/Godthab" do
      assert_time_zone("America/Godthab")
    end

    test "returns transformed data for time zone America/Indiana/Knox" do
      assert_time_zone("America/Indiana/Knox")
    end

    @tag :tel
    test "returns transformed data for time zone America/Indiana/Tell_City" do
      assert_time_zone("America/Indiana/Tell_City")
    end

    @tag :win
    test "returns transformed data for time zone America/Indiana/Winamac" do
      assert_time_zone("America/Indiana/Winamac")
    end

    @tag :jun
    test "returns transformed data for time zone America/Juneau" do
      assert_time_zone("America/Juneau")
    end

    @tag :mon
    test "returns transformed data for time zone America/Montevideo" do
      assert_time_zone("America/Montevideo")
    end

    @tag :san
    test "returns transformed data for time zone America/Santiago" do
      assert_time_zone("America/Santiago")
    end

    test "returns transformed data for time zone America/Sao_Paulo" do
      assert_time_zone("America/Sao_Paulo")
    end

    @tag :mac
    test "returns transformed data for time zone Antarctica/Macquarie" do
      assert_time_zone("Antarctica/Macquarie")
    end

    @tag :aqt
    test "returns transformed data for time zone Asia/Aqtau" do
      assert_time_zone("Asia/Aqtau")
    end

    @tag :tbi
    test "returns transformed data for time zone Asia/Tbilisi" do
      assert_time_zone("Asia/Tbilisi")
    end

    @tag :teh
    test "returns transformed data for time zone Asia/Tehran" do
      assert_time_zone("Asia/Tehran")
    end

    @tag :sha
    test "returns transformed data for time zone Asia/Shanghai" do
      assert_time_zone("Asia/Shanghai")
    end

    @tag :yek
    test "returns transformed data for time zone Asia/Yekaterinburg" do
      assert_time_zone("Asia/Yekaterinburg")
    end

    test "returns transformed data for time zone Europe/Belgrade" do
      assert_time_zone("Europe/Belgrade")
    end

    @tag :ber
    test "returns transformed data for time zone Europe/Berlin" do
      assert_time_zone("Europe/Berlin")
    end

    test "returns transformed data for time zone Europe/Dublin" do
      assert_time_zone("Europe/Dublin")
    end

    @tag :ist
    test "returns transformed data for time zone Europe/Istanbul" do
      assert_time_zone("Europe/Istanbul")
    end

    test "returns transformed data for time zone Europe/London" do
      assert_time_zone("Europe/London")
    end

    test "returns transformed data for time zone Europe/Luxembourg" do
      assert_time_zone("Europe/Luxembourg")
    end

    test "returns transformed data for time zone Europe/Oslo" do
      assert_time_zone("Europe/Oslo")
    end

    @tag :vie
    test "returns transformed data for time zone Europe/Vienna" do
      assert_time_zone("Europe/Vienna")
    end

    @tag :vil
    test "returns transformed data for time zone Europe/Vilnius" do
      assert_time_zone("Europe/Vilnius")
    end

    test "returns transformed data for time zone Pacific/Auckland" do
      assert_time_zone("Pacific/Auckland")
    end
  end

  describe "transform/1 world" do
    # @tag :skip
    @tag :links
    test "links", %{data: data} do
      assert Map.get(data.links, "Antarctica/McMurdo") == "Pacific/Auckland"
    end

    # @tag :skip
    test "rules", %{data: data} do
      assert Map.get(data.rules, "EU") == [
               {{10, [last_day_of_week: 7], 1, 0, 0}, :utc, 0, nil},
               {{3, [last_day_of_week: 7], 1, 0, 0}, :utc, 3600, "S"}
             ]
    end

    # @tag :skip
    @tag :tzv
    test "against tzvalidate", %{data: data} do
      read_tzvalidate()
      |> Enum.sort(fn {a, _}, {b, _} -> a < b end)
      |> Enum.each(fn {time_zone, transitions} ->
        transitions = Enum.reverse(transitions)

        origs =
          case get_time_zone(data, time_zone) do
            {:ok, origs} -> origs
            :error -> flunk("#{time_zone} not found")
          end

        IO.inspect("--- #{time_zone} ---")

        origs
        |> Enum.reverse()
        |> Enum.zip(transitions)
        |> Enum.each(fn
          {{at, {utc_offset, std_offset, zone_abbr}} = orig, tzd}
          when is_integer(std_offset) ->
            # IO.inspect("----")
            # IO.inspect(orig, label: :orig)
            # IO.inspect(tzd, label: :tzd)
            tzi = {at, utc_offset + std_offset, std_offset != 0, zone_abbr}

            # IO.inspect([tzi: tzi, tzd: tzd], label: :compare)

            assert tzi == tzd, """
            #{time_zone} #{NaiveDateTimeUtil.from_gregorian_seconds(at)}:
            orig:       #{inspect(orig)}
            tzvalidate: #{inspect(tzd)}
            """

          _ ->
            :ok
        end)
      end)
    end
  end

  defp assert_time_zone(time_zones, "Africa/Algiers" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1981-05-01 00:00:00Z +01:00:00 standard CET
        {~N[1981-05-01 00:00:00], {3600, 0, "CET"}},
        #   1980-10-31 01:00:00Z +00:00:00 standard WET
        {~N[1980-10-31 01:00:00], {0, 0, "WET"}},
        #   1980-04-25 00:00:00Z +01:00:00 daylight WEST
        {~N[1980-04-25 00:00:00], {0, 3600, "WEST"}},
        #   1979-10-25 23:00:00Z +00:00:00 standard WET
        {~N[1979-10-25 23:00:00], {0, 0, "WET"}},
        #   1978-09-22 01:00:00Z +01:00:00 standard CET
        {~N[1978-09-22 01:00:00], {3600, 0, "CET"}},
        #   1978-03-24 00:00:00Z +02:00:00 daylight CEST
        {~N[1978-03-24 00:00:00], {3600, 3600, "CEST"}},
        #   1977-10-20 23:00:00Z +01:00:00 standard CET
        {~N[1977-10-20 23:00:00], {3600, 0, "CET"}},
        #   1977-05-06 00:00:00Z +01:00:00 daylight WEST
        {~N[1977-05-06 00:00:00], {0, 3600, "WEST"}},
        #   1971-09-26 23:00:00Z +00:00:00 standard WET
        {~N[1971-09-26 23:00:00], {0, 0, "WET"}}
      ],
      [
        #   1916-10-01 23:00:00Z +00:00:00 standard WET
        {~N[1916-06-14 23:00:00], {0, 3600, "WEST"}},
        #   1911-03-10 23:50:39Z +00:00:00 standard WET
        {~N[1911-03-10 23:50:39], {0, 0, "WET"}},
        #   1891-03-14 23:48:48Z +00:09:21 standard PMT
        {~N[1891-03-14 23:48:48], {561, 0, "PMT"}},
        {~N[0000-01-01 00:00:00], {732, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Africa/Nairobi" = tz) do
    assert_time_zone(time_zones, tz, [
      {~N[1959-12-31 21:15:00], {10800, 0, "EAT"}},
      {~N[1939-12-31 21:30:00], {9900, 0, "+0245"}},
      {~N[1929-12-31 21:00:00], {9000, 0, "+0230"}},
      {~N[1928-06-30 21:32:44], {10800, 0, "EAT"}},
      {~N[0000-01-01 00:00:00], {8836, 0, "LMT"}}
    ])
  end

  defp assert_time_zone(time_zones, "America/Adak" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1984-04-29 12:00:00Z -09:00:00 daylight HDT
        {~N[1984-04-29 12:00:00], {-36000, 3600, "HDT"}},
        #   1983-11-30 10:00:00Z -10:00:00 standard HST
        {~N[1983-11-30 10:00:00], {-36000, 0, "HST"}},
        #   1983-10-30 12:00:00Z -10:00:00 standard AHST
        {~N[1983-10-30 12:00:00], {-36000, 0, "AHST"}},
        #   1983-04-24 13:00:00Z -10:00:00 daylight BDT
        {~N[1983-04-24 13:00:00], {-39600, 3600, "BDT"}},
        #   1982-10-31 12:00:00Z -11:00:00 standard BST
        {~N[1982-10-31 12:00:00], {-39600, 0, "BST"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Cancun" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2015-02-01 08:00:00], {-18000, 0, "EST"}},
        {~N[2014-10-26 07:00:00], {-21600, 0, "CST"}},
        {~N[2014-04-06 08:00:00], {-21600, 3600, "CDT"}},
        {~N[2013-10-27 07:00:00], {-21600, 0, "CST"}},
        {~N[2013-04-07 08:00:00], {-21600, 3600, "CDT"}}
      ],
      [
        #   2000-10-29 07:00:00Z -06:00:00 standard CST
        {~N[2000-10-29 07:00:00], {-21600, 0, "CST"}},
        #   2000-04-02 08:00:00Z -05:00:00 daylight CDT
        {~N[2000-04-02 08:00:00], {-21600, 3600, "CDT"}},
        #   1999-10-31 07:00:00Z -06:00:00 standard CST
        {~N[1999-10-31 07:00:00], {-21600, 0, "CST"}},
        #   1999-04-04 08:00:00Z -05:00:00 daylight CDT
        {~N[1999-04-04 08:00:00], {-21600, 3600, "CDT"}},
        #   1998-10-25 07:00:00Z -06:00:00 standard CST
        {~N[1998-10-25 07:00:00], {-21600, 0, "CST"}},
        #   1998-08-02 06:00:00Z -05:00:00 daylight CDT
        {~N[1998-08-02 06:00:00], {-21600, 3600, "CDT"}},
        #   1998-04-05 07:00:00Z -04:00:00 daylight EDT
        {~N[1998-04-05 07:00:00], {-18000, 3600, "EDT"}},
        #   1997-10-26 06:00:00Z -05:00:00 standard EST
        {~N[1997-10-26 06:00:00], {-18000, 0, "EST"}},
        #   1997-04-06 07:00:00Z -04:00:00 daylight EDT
        {~N[1997-04-06 07:00:00], {-18000, 3600, "EDT"}},
        #   1996-10-27 06:00:00Z -05:00:00 standard EST
        {~N[1996-10-27 06:00:00], {-18000, 0, "EST"}},
        #   1996-04-07 07:00:00Z -04:00:00 daylight EDT
        {~N[1996-04-07 07:00:00], {-18000, 3600, "EDT"}},
        #   1981-12-23 06:00:00Z -05:00:00 standard EST
        {~N[1981-12-23 06:00:00], {-18000, 0, "EST"}},
        #   1922-01-01 06:00:00Z -06:00:00 standard CST
        {~N[1922-01-01 06:00:00], {-21600, 0, "CST"}},
        #   Initially:           -05:47:04 standard LMT
        {~N[0000-01-01 00:00:00], {-20824, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Caracas" = tz) do
    assert_time_zone(time_zones, tz, [
      {~N[2016-05-01 07:00:00], {-14400, 0, "-04"}},
      {~N[2007-12-09 07:00:00], {-16200, 0, "-0430"}},
      {~N[1965-01-01 04:30:00], {-14400, 0, "-04"}},
      {~N[1912-02-12 04:27:40], {-16200, 0, "-0430"}},
      {~N[1890-01-01 04:27:44], {-16060, 0, "CMT"}},
      {~N[0000-01-01 00:00:00], {-16064, 0, "LMT"}}
    ])
  end

  defp assert_time_zone(time_zones, "America/Dawson" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-11-07 09:00:00], {-28800, "Canada", {:template, "P%sT"}}},
        {~N[2021-03-14 10:00:00], {-28800, 3600, "PDT"}},
        {~N[2020-11-01 09:00:00], {-28800, 0, "PST"}},
        {~N[2020-03-08 10:00:00], {-28800, 3600, "PDT"}}
      ],
      [
        #   1981-04-26 10:00:00Z -07:00:00 daylight PDT
        {~N[1981-04-26 10:00:00], {-28800, 3600, "PDT"}},
        #   1980-10-26 09:00:00Z -08:00:00 standard PST
        {~N[1980-10-26 09:00:00], {-28800, 0, "PST"}},
        #   1980-04-27 10:00:00Z -07:00:00 daylight PDT
        {~N[1980-04-27 10:00:00], {-28800, 3600, "PDT"}},
        #   1973-10-28 09:00:00Z -08:00:00 standard PST
        {~N[1973-10-28 09:00:00], {-28800, 0, "PST"}},
        #   1965-10-31 09:00:00Z -09:00:00 standard YST
        {~N[1965-10-31 09:00:00], {-32400, 0, "YST"}},
        #   1965-04-25 09:00:00Z -07:00:00 daylight YDDT
        {~N[1965-04-25 09:00:00], {-32400, 7200, "YDDT"}},
        #   1945-09-30 10:00:00Z -09:00:00 standard YST
        {~N[1945-09-30 10:00:00], {-32400, 0, "YST"}},
        #   1945-08-14 23:00:00Z -08:00:00 daylight YPT
        {~N[1945-08-14 23:00:00], {-32400, 3600, "YPT"}},
        #   1942-02-09 11:00:00Z -08:00:00 daylight YWT
        {~N[1942-02-09 11:00:00], {-32400, 3600, "YWT"}},
        #   1919-11-01 08:00:00Z -09:00:00 standard YST
        {~N[1919-11-01 08:00:00], {-32400, 0, "YST"}},
        #   1919-05-25 11:00:00Z -08:00:00 daylight YDT
        {~N[1919-05-25 11:00:00], {-32400, 3600, "YDT"}}
      ],
      [
        #   1918-10-27 10:00:00Z -09:00:00 standard YST
        {~N[1918-10-27 10:00:00], {-32400, 0, "YST"}},
        #   1918-04-14 11:00:00Z -08:00:00 daylight YDT
        {~N[1918-04-14 11:00:00], {-32400, 3600, "YDT"}},
        #   1900-08-20 09:17:40Z -09:00:00 standard YST
        {~N[1900-08-20 09:17:40], {-32400, 0, "YST"}},
        # Initially:           -09:17:40 standard LMT
        {~N[0000-01-01 00:00:00], {-33460, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Godthab" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1982-09-26 01:00:00Z -03:00:00 standard -03
        {~N[1982-09-26 01:00:00], {-10800, 0, "-03"}},
        #   1982-03-28 01:00:00Z -02:00:00 daylight -02
        {~N[1982-03-28 01:00:00], {-10800, 3600, "-02"}},
        #   1981-09-27 01:00:00Z -03:00:00 standard -03
        {~N[1981-09-27 01:00:00], {-10800, 0, "-03"}},
        #   1981-03-29 01:00:00Z -02:00:00 daylight -02
        {~N[1981-03-29 01:00:00], {-10800, 3600, "-02"}},
        #   1980-09-28 01:00:00Z -03:00:00 standard -03
        {~N[1980-09-28 01:00:00], {-10800, 0, "-03"}},
        #   1980-04-06 05:00:00Z -02:00:00 daylight -02
        {~N[1980-04-06 05:00:00], {-10800, 3600, "-02"}}
      ],
      [
        #   1916-07-28 03:26:56Z -03:00:00 standard -03
        {~N[1916-07-28 03:26:56], {-10800, 0, "-03"}},
        #   Initially:           -03:26:56 standard LMT
        {~N[0000-01-01 00:00:00], {-12416, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Indiana/Knox" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[1918-03-31 08:00:00], {-21600, 3600, "CDT"}},
        {~N[1883-11-18 18:00:00], {-21600, 0, "CST"}},
        {~N[0000-01-01 00:00:00], {-20790, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Indiana/Tell_City" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[1968-04-28 08:00:00], {-21600, 3600, "CDT"}},
        {~N[1967-10-29 07:00:00], {-21600, 0, "CST"}},
        {~N[1964-04-26 08:00:00], {-18000, 0, "EST"}}
      ],
      [
        {~N[1918-03-31 08:00:00], {-21600, 3600, "CDT"}},
        {~N[1883-11-18 18:00:00], {-21600, 0, "CST"}},
        {~N[0000-01-01 00:00:00], {-20823, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Indiana/Winamac" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   2008-11-02 06:00:00Z -05:00:00 standard EST
        {~N[2008-11-02 06:00:00], {-18000, 0, "EST"}},
        #   2008-03-09 07:00:00Z -04:00:00 daylight EDT
        {~N[2008-03-09 07:00:00], {-18000, 3600, "EDT"}},
        #   2007-11-04 06:00:00Z -05:00:00 standard EST
        {~N[2007-11-04 06:00:00], {-18000, 0, "EST"}},
        #   2007-03-11 08:00:00Z -04:00:00 daylight EDT
        {~N[2007-03-11 08:00:00], {-18000, 3600, "EDT"}},
        #   2006-10-29 07:00:00Z -06:00:00 standard CST
        {~N[2006-10-29 07:00:00], {-21600, 0, "CST"}},
        #   2006-04-02 07:00:00Z -05:00:00 daylight CDT
        {~N[2006-04-02 07:00:00], {-21600, 3600, "CDT"}},
        #   1970-10-25 06:00:00Z -05:00:00 standard EST
        {~N[1970-10-25 06:00:00], {-18000, 0, "EST"}},
        #   1970-04-26 07:00:00Z -04:00:00 daylight EDT
        {~N[1970-04-26 07:00:00], {-18000, 3600, "EDT"}},
        #   1969-10-26 06:00:00Z -05:00:00 standard EST
        {~N[1969-10-26 06:00:00], {-18000, 0, "EST"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Los_Angeles" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-11-07 09:00:00], {-28800, "US", {:template, "P%sT"}}},
        {~N[2021-03-14 10:00:00], {-28800, 3600, "PDT"}}
      ],
      [
        {~N[1918-03-31 10:00:00], {-28800, 3600, "PDT"}},
        {~N[1883-11-18 20:00:00], {-28800, 0, "PST"}},
        {~N[0000-01-01 00:00:00], {-28378, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Port_of_Spain" = tz) do
    assert_time_zone(time_zones, tz, [
      {~N[1912-03-02 04:06:04], {-14400, 0, "AST"}},
      {~N[0000-01-01 00:00:00], {-14764, 0, "LMT"}}
    ])
  end

  defp assert_time_zone(time_zones, "America/Juneau" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1984-10-28 10:00:00Z -09:00:00 standard AKST
        {~N[1984-10-28 10:00:00], {-32400, 0, "AKST"}},
        #   1984-04-29 11:00:00Z -08:00:00 daylight AKDT
        {~N[1984-04-29 11:00:00], {-32400, 3600, "AKDT"}},
        #   1983-11-30 09:00:00Z -09:00:00 standard AKST
        {~N[1983-11-30 09:00:00], {-32400, 0, "AKST"}},
        #   1983-10-30 09:00:00Z -09:00:00 standard YST
        {~N[1983-10-30 09:00:00], {-32400, 0, "YST"}},
        #   1983-04-24 10:00:00Z -07:00:00 daylight PDT
        {~N[1983-04-24 10:00:00], {-28800, 3600, "PDT"}},
        #   1982-10-31 09:00:00Z -08:00:00 standard PST
        {~N[1982-10-31 09:00:00], {-28800, 0, "PST"}},
        #   1982-04-25 10:00:00Z -07:00:00 daylight PDT
        {~N[1982-04-25 10:00:00], {-28800, 3600, "PDT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Montevideo" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1976-12-19 03:00:00Z -02:00:00 daylight -02
        {~N[1976-12-19 03:00:00], {-10800, 3600, "-02"}},
        #   1975-03-30 02:00:00Z -03:00:00 standard -03
        {~N[1975-03-30 02:00:00], {-10800, 0, "-03"}},
        #   1974-12-22 03:00:00Z -02:00:00 daylight -02
        {~N[1974-12-22 03:00:00], {-10800, 3600, "-02"}},
        #   1974-09-01 02:30:00Z -03:00:00 standard -03
        {~N[1974-09-01 02:30:00], {-10800, 0, "-03"}},
        #   1974-03-10 01:30:00Z -02:30:00 daylight -0230
        {~N[1974-03-10 01:30:00], {-10800, 1800, "-0230"}},
        #   1974-01-13 03:00:00Z -01:30:00 daylight -0130
        {~N[1974-01-13 03:00:00], {-10800, 5400, "-0130"}},
        #   1972-07-16 02:00:00Z -03:00:00 standard -03
        {~N[1972-07-16 02:00:00], {-10800, 0, "-03"}}
      ],
      [
        #   1959-05-24 03:00:00Z -02:30:00 daylight -0230
        {~N[1959-05-24 03:00:00], {-10800, 1800, "-0230"}},
        #   1943-03-14 02:30:00Z -03:00:00 standard -03
        {~N[1943-03-14 02:30:00], {-10800, 0, "-03"}},
        #   1942-12-14 03:00:00Z -02:30:00 daylight -0230
        {~N[1942-12-14 03:00:00], {-10800, 1800, "-0230"}},
        #   1941-08-01 03:30:00Z -03:00:00 daylight -03
        {~N[1941-08-01 03:30:00], {-12600, 1800, "-03"}},
        #   1941-03-30 03:00:00Z -03:30:00 standard -0330
        {~N[1941-03-30 03:00:00], {-12600, 0, "-0330"}}
      ],
      [
        #   1924-10-01 03:30:00Z -03:00:00 daylight -03
        {~N[1924-10-01 03:30:00], {-12600, 1800, "-03"}},
        #   1924-04-01 03:00:00Z -03:30:00 standard -0330
        {~N[1924-04-01 03:00:00], {-12600, 0, "-0330"}},
        #   1923-10-01 04:00:00Z -03:00:00 daylight -03
        {~N[1923-10-01 04:00:00], {-12600, 1800, "-03"}},
        #   1920-05-01 03:44:51Z -04:00:00 standard -04
        {~N[1920-05-01 03:44:51], {-14400, 0, "-04"}},
        #   1908-06-10 03:44:51Z -03:44:51 standard MMT
        {~N[1908-06-10 03:44:51], {-13491, 0, "MMT"}},
        #   Initially:           -03:44:51 standard LMT
        {~N[0000-01-01 00:00:00], {-13491, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Santiago" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1929-09-01 05:00:00Z -04:00:00 daylight -04
        {~N[1929-09-01 05:00:00], {-18000, 3600, "-04"}},
        #   1929-04-01 04:00:00Z -05:00:00 standard -05
        {~N[1929-04-01 04:00:00], {-18000, 0, "-05"}},
        #   1928-09-01 05:00:00Z -04:00:00 daylight -04
        {~N[1928-09-01 05:00:00], {-18000, 3600, "-04"}},
        #   1928-04-01 04:00:00Z -05:00:00 standard -05
        {~N[1928-04-01 04:00:00], {-18000, 0, "-05"}},
        #   1927-09-01 04:42:46Z -04:00:00 daylight -04
        {~N[1927-09-01 04:42:46], {-18000, 3600, "-04"}},
        #   1919-07-01 04:00:00Z -04:42:46 standard SMT
        {~N[1919-07-01 04:00:00], {-16966, 0, "SMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "America/Sao_Paulo" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1966-03-01 02:00:00Z -03:00:00 standard -03
        {~N[1966-03-01 02:00:00], {-10800, 0, "-03"}},
        #   1965-12-01 03:00:00Z -02:00:00 daylight -02
        {~N[1965-12-01 03:00:00], {-10800, 3600, "-02"}},
        #   1965-03-31 02:00:00Z -03:00:00 standard -03
        {~N[1965-03-31 02:00:00], {-10800, 0, "-03"}},
        #   1965-01-31 03:00:00Z -02:00:00 daylight -02
        {~N[1965-01-31 03:00:00], {-10800, 3600, "-02"}},
        #   1964-03-01 02:00:00Z -03:00:00 standard -03
        {~N[1964-03-01 02:00:00], {-10800, 0, "-03"}},
        #   1963-10-23 03:00:00Z -02:00:00 daylight -02
        {~N[1963-10-23 03:00:00], {-10800, 3600, "-02"}},
        #   1953-03-01 02:00:00Z -03:00:00 standard -03
        {~N[1953-03-01 02:00:00], {-10800, 0, "-03"}},
        #   1952-12-01 03:00:00Z -02:00:00 daylight -02
        {~N[1952-12-01 03:00:00], {-10800, 3600, "-02"}}
      ],
      [
        {~N[1931-10-03 14:00:00], {-10800, 3600, "-02"}},
        {~N[1914-01-01 03:06:28], {-10800, 0, "-03"}},
        {~N[0000-01-01 00:00:00], {-11188, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Antarctica/Macquarie" = tz) do
    assert_time_zone(time_zones, tz, [
      [

        #   1967-09-30 16:00:00Z +11:00:00 daylight AEDT
        {~N[1967-09-30 16:00:00], {36000, 3600, "AEDT"}},
        #   1948-03-25 00:00:00Z +10:00:00 standard AEST
        {~N[1948-03-25 00:00:00], {36000, 0, "AEST"}},
        #   1919-03-31 14:00:00Z +00:00:00 standard -00
        {~N[1919-03-31 14:00:00], {0, 0, "-00"}},
        #   1917-03-24 15:00:00Z +10:00:00 standard AEST
        {~N[1917-03-24 15:00:00], {36000, 0, "AEST"}},
        #   1916-09-30 16:00:00Z +11:00:00 daylight AEDT
        {~N[1916-09-30 16:00:00], {36000, 3600, "AEDT"}},
        #   1899-11-01 00:00:00Z +10:00:00 standard AEST
        {~N[1899-11-01 00:00:00], {36000, 0, "AEST"}},
        #   Initially:           +00:00:00 standard -00
        {~N[0000-01-01 00:00:00], {0, 0, "-00"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Aqtau" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   2004-10-30 22:00:00Z +05:00:00 standard +05
        {~N[2004-10-30 22:00:00], {18000, 0, "+05"}},
        #   2004-03-27 22:00:00Z +05:00:00 daylight +05
        {~N[2004-03-27 22:00:00], {14400, 3600, "+05"}},
        #   2003-10-25 22:00:00Z +04:00:00 standard +04
        {~N[2003-10-25 22:00:00], {14400, 0, "+04"}}
      ],
      [
        #   1997-10-25 22:00:00Z +04:00:00 standard +04
        {~N[1997-10-25 22:00:00], {14400, 0, "+04"}},
        #   1997-03-29 22:00:00Z +05:00:00 daylight +05
        {~N[1997-03-29 22:00:00], {14400, 3600, "+05"}},
        #   1996-10-26 22:00:00Z +04:00:00 standard +04
        {~N[1996-10-26 22:00:00], {14400, 0, "+04"}},
        #   1996-03-30 22:00:00Z +05:00:00 daylight +05
        {~N[1996-03-30 22:00:00], {14400, 3600, "+05"}},
        #   1995-09-23 22:00:00Z +04:00:00 standard +04
        {~N[1995-09-23 22:00:00], {14400, 0, "+04"}},
        #   1995-03-25 22:00:00Z +05:00:00 daylight +05
        {~N[1995-03-25 22:00:00], {14400, 3600, "+05"}},
        #   1994-09-24 21:00:00Z +04:00:00 standard +04
        {~N[1994-09-24 21:00:00], {14400, 0, "+04"}},
        #   1994-03-26 21:00:00Z +06:00:00 daylight +06
        {~N[1994-03-26 21:00:00], {18000, 3600, "+06"}},
        #   1993-09-25 21:00:00Z +05:00:00 standard +05
        {~N[1993-09-25 21:00:00], {18000, 0, "+05"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Tbilisi" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2005-03-26 23:00:00], {14400, 0, "+04"}},
        {~N[2004-10-30 23:00:00], {10800, 0, "+03"}},
        {~N[2004-06-26 19:00:00], {10800, 3600, "+04"}},
        {~N[2004-03-27 20:00:00], {14400, 3600, "+05"}},
        {~N[2003-10-25 19:00:00], {14400, 0, "+04"}},
        {~N[2003-03-29 20:00:00], {14400, 3600, "+05"}},
        {~N[2002-10-26 19:00:00], {14400, 0, "+04"}},
        {~N[2002-03-30 20:00:00], {14400, 3600, "+05"}},
        {~N[2001-10-27 19:00:00], {14400, 0, "+04"}},
        {~N[2001-03-24 20:00:00], {14400, 3600, "+05"}},
        {~N[2000-10-28 19:00:00], {14400, 0, "+04"}},
        {~N[2000-03-25 20:00:00], {14400, 3600, "+05"}},
        {~N[1999-10-30 19:00:00], {14400, 0, "+04"}},
        {~N[1999-03-27 20:00:00], {14400, 3600, "+05"}},
        {~N[1998-10-24 19:00:00], {14400, 0, "+04"}},
        #   1998-03-28 20:00:00Z +05:00:00 daylight +05
        {~N[1998-03-28 20:00:00], {14400, 3600, "+05"}},
        #   1997-10-25 19:00:00Z +04:00:00 standard +04
        {~N[1997-10-25 19:00:00], {14400, 0, "+04"}},
        #   1996-03-30 20:00:00Z +05:00:00 daylight +05
        {~N[1996-03-30 20:00:00], {14400, 3600, "+05"}},
        #   1995-09-23 19:00:00Z +04:00:00 standard +04
        {~N[1995-09-23 19:00:00], {14400, 0, "+04"}},
        #   1995-03-25 20:00:00Z +05:00:00 daylight +05
        {~N[1995-03-25 20:00:00], {14400, 3600, "+05"}},
        #   1994-09-24 20:00:00Z +04:00:00 standard +04
        {~N[1994-09-24 20:00:00], {14400, 0, "+04"}},
        #   1994-03-26 21:00:00Z +04:00:00 daylight +04
        {~N[1994-03-26 21:00:00], {10800, 3600, "+04"}}
      ],
      [
        {~N[1981-09-30 19:00:00], {14400, 0, "+04"}},
        {~N[1981-03-31 20:00:00], {14400, 3600, "+05"}},
        {~N[1957-02-28 21:00:00], {14400, 0, "+04"}},
        {~N[1924-05-01 21:00:49], {10800, 0, "+03"}},
        {~N[1879-12-31 21:00:49], {10751, 0, "TBMT"}},
        {~N[0000-01-01 00:00:00], {10751, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Tehran" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1980-09-22 19:30:00Z +03:30:00 standard +0330
        {~N[1980-09-22 19:30:00], {12600, 0, "+0330"}},
        #   1980-03-20 20:30:00Z +04:30:00 daylight +0430
        {~N[1980-03-20 20:30:00], {12600, 3600, "+0430"}},
        #   1979-09-18 19:30:00Z +03:30:00 standard +0330
        {~N[1979-09-18 19:30:00], {12600, 0, "+0330"}},
        #   1979-03-20 20:30:00Z +04:30:00 daylight +0430
        {~N[1979-03-20 20:30:00], {12600, 3600, "+0430"}},
        #   1978-12-31 20:00:00Z +03:30:00 standard +0330
        {~N[1978-12-31 20:00:00], {12600, 0, "+0330"}},
        #   1978-10-20 19:00:00Z +04:00:00 standard +04
        {~N[1978-10-20 19:00:00], {14400, 0, "+04"}},
        #   1978-03-20 20:00:00Z +05:00:00 daylight +05
        {~N[1978-03-20 20:00:00], {14400, 3600, "+05"}},
        #   1977-10-31 20:30:00Z +04:00:00 standard +04
        {~N[1977-10-31 20:30:00], {14400, 0, "+04"}},
        #   1945-12-31 20:34:16Z +03:30:00 standard +0330
        {~N[1945-12-31 20:34:16], {12600, 0, "+0330"}},
        #   1915-12-31 20:34:16Z +03:25:44 standard TMT
        {~N[1915-12-31 20:34:16], {12344, 0, "TMT"}},
        #   Initially:           +03:25:44 standard LMT
        {~N[0000-01-01 00:00:00], {12344, 0, "LMT"}}
      ],
      [
        #   2024-09-20 19:30:00Z +03:30:00 standard +0330
        {~N[2024-09-20 19:30:00], {12600, 0, "+0330"}},
        #   2024-03-20 20:30:00Z +04:30:00 daylight +0430
        {~N[2024-03-20 20:30:00], {12600, 3600, "+0430"}},
        #   2023-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2023-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2023-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2023-03-21 20:30:00], {12600, 3600, "+0430"}},
        #   2022-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2022-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2022-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2022-03-21 20:30:00], {12600, 3600, "+0430"}},
        #   2021-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2021-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2021-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2021-03-21 20:30:00], {12600, 3600, "+0430"}},
        #   2020-09-20 19:30:00Z +03:30:00 standard +0330
        {~N[2020-09-20 19:30:00], {12600, 0, "+0330"}},
        #   2020-03-20 20:30:00Z +04:30:00 daylight +0430
        {~N[2020-03-20 20:30:00], {12600, 3600, "+0430"}},
        #   2019-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2019-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2019-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2019-03-21 20:30:00], {12600, 3600, "+0430"}},
        #   2018-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2018-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2018-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2018-03-21 20:30:00], {12600, 3600, "+0430"}},
        #   2017-09-21 19:30:00Z +03:30:00 standard +0330
        {~N[2017-09-21 19:30:00], {12600, 0, "+0330"}},
        #   2017-03-21 20:30:00Z +04:30:00 daylight +0430
        {~N[2017-03-21 20:30:00], {12600, 3600, "+0430"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Shanghai" = tz) do
    assert_time_zone(time_zones, tz, [
      #   1991-09-14 17:00:00Z +08:00:00 standard CST
      {~N[1991-09-14 17:00:00], {28800, 0, "CST"}},
      #   1991-04-13 18:00:00Z +09:00:00 daylight CDT
      {~N[1991-04-13 18:00:00], {28800, 3600, "CDT"}},
      #   1990-09-15 17:00:00Z +08:00:00 standard CST
      {~N[1990-09-15 17:00:00], {28800, 0, "CST"}},
      #   1990-04-14 18:00:00Z +09:00:00 daylight CDT
      {~N[1990-04-14 18:00:00], {28800, 3600, "CDT"}},
      #   1989-09-16 17:00:00Z +08:00:00 standard CST
      {~N[1989-09-16 17:00:00], {28800, 0, "CST"}},
      #   1989-04-15 18:00:00Z +09:00:00 daylight CDT
      {~N[1989-04-15 18:00:00], {28800, 3600, "CDT"}},
      #   1988-09-10 17:00:00Z +08:00:00 standard CST
      {~N[1988-09-10 17:00:00], {28800, 0, "CST"}},
      #   1988-04-16 18:00:00Z +09:00:00 daylight CDT
      {~N[1988-04-16 18:00:00], {28800, 3600, "CDT"}},
      #   1987-09-12 17:00:00Z +08:00:00 standard CST
      {~N[1987-09-12 17:00:00], {28800, 0, "CST"}},
      #   1987-04-11 18:00:00Z +09:00:00 daylight CDT
      {~N[1987-04-11 18:00:00], {28800, 3600, "CDT"}},
      #   1986-09-13 17:00:00Z +08:00:00 standard CST
      {~N[1986-09-13 17:00:00], {28800, 0, "CST"}},
      #   1986-05-03 18:00:00Z +09:00:00 daylight CDT
      {~N[1986-05-03 18:00:00], {28800, 3600, "CDT"}},
      #   1949-05-27 15:00:00Z +08:00:00 standard CST
      {~N[1949-05-27 15:00:00], {28800, 0, "CST"}},
      #   1949-04-30 16:00:00Z +09:00:00 daylight CDT
      {~N[1949-04-30 16:00:00], {28800, 3600, "CDT"}},
      #   1948-09-30 15:00:00Z +08:00:00 standard CST
      {~N[1948-09-30 15:00:00], {28800, 0, "CST"}},
      #   1948-04-30 16:00:00Z +09:00:00 daylight CDT
      {~N[1948-04-30 16:00:00], {28800, 3600, "CDT"}},
      #   1947-10-31 15:00:00Z +08:00:00 standard CST
      {~N[1947-10-31 15:00:00], {28800, 0, "CST"}},
      #   1947-04-14 16:00:00Z +09:00:00 daylight CDT
      {~N[1947-04-14 16:00:00], {28800, 3600, "CDT"}},
      #   1946-09-30 15:00:00Z +08:00:00 standard CST
      {~N[1946-09-30 15:00:00], {28800, 0, "CST"}},
      #   1946-05-14 16:00:00Z +09:00:00 daylight CDT
      {~N[1946-05-14 16:00:00], {28800, 3600, "CDT"}},
      #   1945-09-01 15:00:00Z +08:00:00 standard CST
      {~N[1945-09-01 15:00:00], {28800, 0, "CST"}},
      #   1942-01-30 16:00:00Z +09:00:00 daylight CDT
      {~N[1942-01-30 16:00:00], {28800, 3600, "CDT"}},
      #   1941-11-01 15:00:00Z +08:00:00 standard CST
      {~N[1941-11-01 15:00:00], {28800, 0, "CST"}},
      #   1941-03-14 16:00:00Z +09:00:00 daylight CDT
      {~N[1941-03-14 16:00:00], {28800, 3600, "CDT"}},
      #   1940-10-12 15:00:00Z +08:00:00 standard CST
      {~N[1940-10-12 15:00:00], {28800, 0, "CST"}},
      #   1940-05-31 16:00:00Z +09:00:00 daylight CDT
      {~N[1940-05-31 16:00:00], {28800, 3600, "CDT"}},
      #   1900-12-31 15:54:17Z +08:00:00 standard CST
      {~N[1900-12-31 15:54:17], {28800, 0, "CST"}},
      #   Initially:           +08:05:43 standard LMT
      {~N[0000-01-01 00:00:00], {29143, 0, "LMT"}}
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Yekaterinburg" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   2014-10-25 20:00:00Z +05:00:00 standard +05
        {~N[2014-10-25 20:00:00], {18000, 0, "+05"}},
        #   2011-03-26 21:00:00Z +06:00:00 standard +06
        {~N[2011-03-26 21:00:00], {21600, 0, "+06"}},
        #   2010-10-30 21:00:00Z +05:00:00 standard +05
        {~N[2010-10-30 21:00:00], {18000, 0, "+05"}},
        #   2010-03-27 21:00:00Z +06:00:00 daylight +06
        {~N[2010-03-27 21:00:00], {18000, 3600, "+06"}}
      ],
      [
        #   1993-03-27 21:00:00Z +06:00:00 daylight +06
        {~N[1993-03-27 21:00:00], {18000, 3600, "+06"}},
        #   1992-09-26 21:00:00Z +05:00:00 standard +05
        {~N[1992-09-26 21:00:00], {18000, 0, "+05"}},
        #   1992-03-28 21:00:00Z +06:00:00 daylight +06
        {~N[1992-03-28 21:00:00], {18000, 3600, "+06"}},
        #   1992-01-18 22:00:00Z +05:00:00 standard +05
        {~N[1992-01-18 22:00:00], {18000, 0, "+05"}},
        #   1991-09-28 22:00:00Z +04:00:00 standard +04
        {~N[1991-09-28 22:00:00], {14400, 0, "+04"}},
        #   1991-03-30 21:00:00Z +05:00:00 daylight +05
        {~N[1991-03-30 21:00:00], {14400, 3600, "+05"}},
        #   1990-09-29 21:00:00Z +05:00:00 standard +05
        {~N[1990-09-29 21:00:00], {18000, 0, "+05"}},
        #   1990-03-24 21:00:00Z +06:00:00 daylight +06
        {~N[1990-03-24 21:00:00], {18000, 3600, "+06"}}
      ],
      [
        #   1981-09-30 18:00:00Z +05:00:00 standard +05
        {~N[1981-09-30 18:00:00], {18000, 0, "+05"}},
        #   1981-03-31 19:00:00Z +06:00:00 daylight +06
        {~N[1981-03-31 19:00:00], {18000, 3600, "+06"}},
        #   1930-06-20 20:00:00Z +05:00:00 standard +05
        {~N[1930-06-20 20:00:00], {18000, 0, "+05"}},
        #   1919-07-15 00:14:55Z +04:00:00 standard +04
        {~N[1919-07-15 00:14:55], {14400, 0, "+04"}},
        #   1916-07-02 19:57:27Z +03:45:05 standard PMT
        {~N[1916-07-02 19:57:27], {13505, 0, "PMT"}},
        #   Initially:           +04:02:33 standard LMT
        {~N[0000-01-01 00:00:00], {14553, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Asia/Taipei" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[1979-09-30 15:00:00], {28800, 0, "CST"}},
        {~N[1979-06-30 16:00:00], {28800, 3600, "CDT"}},
        {~N[1975-09-30 15:00:00], {28800, 0, "CST"}},
        {~N[1975-03-31 16:00:00], {28800, 3600, "CDT"}},
        {~N[1974-09-30 15:00:00], {28800, 0, "CST"}},
        {~N[1974-03-31 16:00:00], {28800, 3600, "CDT"}},
        {~N[1961-09-30 15:00:00], {28800, 0, "CST"}},
        {~N[1961-05-31 16:00:00], {28800, 3600, "CDT"}}
      ],
      [
        {~N[1946-09-30 15:00:00], {28800, 0, "CST"}},
        {~N[1946-05-14 16:00:00], {28800, 3600, "CDT"}},
        {~N[1945-09-20 16:00:00], {28800, 0, "CST"}},
        {~N[1937-09-30 16:00:00], {32400, 0, "JST"}},
        {~N[1895-12-31 15:54:00], {28800, 0, "CST"}},
        {~N[0000-01-01 00:00:00], {29160, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Australia/Adelaide" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-10-02 16:30:00], {34200, "AS", {:template, "AC%sT"}}},
        {~N[2021-04-03 16:30:00], {34200, 0, "ACST"}}
      ],
      [
        {~N[1916-12-31 14:31:00], {34200, 3600, "ACDT"}},
        {~N[1899-04-30 15:00:00], {34200, 0, "ACST"}},
        {~N[1895-01-31 14:45:40], {32400, 0, "ACST"}},
        {~N[0000-01-01 00:00:00], {33260, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Belgrade" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1943-10-04 01:00:00Z +01:00:00 standard CET
        {~N[1943-10-04 01:00:00], {3600, 0, "CET"}},
        #   1943-03-29 01:00:00Z +02:00:00 daylight CEST
        {~N[1943-03-29 01:00:00], {3600, 3600, "CEST"}},
        #   1942-11-02 01:00:00Z +01:00:00 standard CET
        {~N[1942-11-02 01:00:00], {3600, 0, "CET"}},
        #   1941-04-18 22:00:00Z +02:00:00 daylight CEST
        {~N[1941-04-18 22:00:00], {3600, 3600, "CEST"}},
        #   1883-12-31 22:38:00Z +01:00:00 standard CET
        {~N[1883-12-31 22:38:00], {3600, 0, "CET"}},
        #   Initially:           +01:22:00 standard LMT
        {~N[0000-01-01 00:00:00], {4920, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Berlin" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-10-31 01:00:00], {3600, "EU", {:template, "CE%sT"}}},
        #   2021-03-28 01:00:00Z +02:00:00 daylight CEST
        {~N[2021-03-28 01:00:00], {3600, 3600, "CEST"}},
        #   2020-10-25 01:00:00Z +01:00:00 standard CET
        {~N[2020-10-25 01:00:00], {3600, 0, "CET"}},
        #   2020-03-29 01:00:00Z +02:00:00 daylight CEST
        {~N[2020-03-29 01:00:00], {3600, 3600, "CEST"}}
      ],
      [
        #   1946-10-07 01:00:00Z +01:00:00 standard CET
        {~N[1946-10-07 01:00:00], {3600, 0, "CET"}},
        #   1946-04-14 01:00:00Z +02:00:00 daylight CEST
        {~N[1946-04-14 01:00:00], {3600, 3600, "CEST"}},
        #   1945-11-18 01:00:00Z +01:00:00 standard CET
        {~N[1945-11-18 01:00:00], {3600, 0, "CET"}},
        #   1945-09-24 00:00:00Z +02:00:00 daylight CEST
        {~N[1945-09-24 00:00:00], {3600, 3600, "CEST"}},
        #   1945-05-24 00:00:00Z +03:00:00 daylight CEMT
        {~N[1945-05-24 00:00:00], {3600, 7200, "CEMT"}},
        #   1945-04-02 01:00:00Z +02:00:00 daylight CEST
        {~N[1945-04-02 01:00:00], {3600, 3600, "CEST"}},
        #   1944-10-02 01:00:00Z +01:00:00 standard CET
        {~N[1944-10-02 01:00:00], {3600, 0, "CET"}},
        #   1944-04-03 01:00:00Z +02:00:00 daylight CEST
        {~N[1944-04-03 01:00:00], {3600, 3600, "CEST"}},
        #   1943-10-04 01:00:00Z +01:00:00 standard CET
        {~N[1943-10-04 01:00:00], {3600, 0, "CET"}},
        #   1943-03-29 01:00:00Z +02:00:00 daylight CEST
        {~N[1943-03-29 01:00:00], {3600, 3600, "CEST"}},
        #   1942-11-02 01:00:00Z +01:00:00 standard CET
        {~N[1942-11-02 01:00:00], {3600, 0, "CET"}},
        #   1940-04-01 01:00:00Z +02:00:00 daylight CEST
        {~N[1940-04-01 01:00:00], {3600, 3600, "CEST"}}
      ],
      [
        {~N[1916-04-30 22:00:00], {3600, 3600, "CEST"}},
        {~N[1893-03-31 23:06:32], {3600, 0, "CET"}},
        {~N[0000-01-01 00:00:00], {3208, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Dublin" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-10-31 01:00:00], {3600, "Eire", {:choice, ["IST", "GMT"]}}},
        {~N[2021-03-28 01:00:00], {3600, 0, "IST"}},
        {~N[2020-10-25 01:00:00], {3600, -3600, "GMT"}},
        {~N[2020-03-29 01:00:00], {3600, 0, "IST"}},
        {~N[2019-10-27 01:00:00], {3600, -3600, "GMT"}},
        {~N[2019-03-31 01:00:00], {3600, 0, "IST"}},
        {~N[2018-10-28 01:00:00], {3600, -3600, "GMT"}},
        {~N[2018-03-25 01:00:00], {3600, 0, "IST"}},
        {~N[2017-10-29 01:00:00], {3600, -3600, "GMT"}},
        {~N[2017-03-26 01:00:00], {3600, 0, "IST"}},
        {~N[2016-10-30 01:00:00], {3600, -3600, "GMT"}}
      ],
      [
        {~N[1917-09-17 02:00:00], {0, 0, "GMT"}},
        {~N[1917-04-08 02:00:00], {0, 3600, "BST"}},
        {~N[1916-10-01 02:25:21], {0, 0, "GMT"}},
        {~N[1916-05-21 02:25:21], {-1521, 3600, "IST"}},
        {~N[1880-08-02 00:25:00], {-1521, 0, "DMT"}},
        {~N[0000-01-01 00:00:00], {-1500, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Istanbul" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   2016-09-06 21:00:00Z +03:00:00 standard +03
        {~N[2016-09-06 21:00:00], {10800, 0, "+03"}},
        #   2016-03-27 01:00:00Z +03:00:00 daylight EEST
        {~N[2016-03-27 01:00:00], {7200, 3600, "EEST"}},
        #   2015-11-08 01:00:00Z +02:00:00 standard EET
        {~N[2015-11-08 01:00:00], {7200, 0, "EET"}},
        #   2015-03-29 01:00:00Z +03:00:00 daylight EEST
        {~N[2015-03-29 01:00:00], {7200, 3600, "EEST"}},
        #   2014-10-26 01:00:00Z +02:00:00 standard EET
        {~N[2014-10-26 01:00:00], {7200, 0, "EET"}},
        #   2014-03-31 01:00:00Z +03:00:00 daylight EEST
        {~N[2014-03-31 01:00:00], {7200, 3600, "EEST"}},
        #   2013-10-27 01:00:00Z +02:00:00 standard EET
        {~N[2013-10-27 01:00:00], {7200, 0, "EET"}},
        #   2013-03-31 01:00:00Z +03:00:00 daylight EEST
        {~N[2013-03-31 01:00:00], {7200, 3600, "EEST"}},
        #   2012-10-28 01:00:00Z +02:00:00 standard EET
        {~N[2012-10-28 01:00:00], {7200, 0, "EET"}},
        #   2012-03-25 01:00:00Z +03:00:00 daylight EEST
        {~N[2012-03-25 01:00:00], {7200, 3600, "EEST"}},
        #   2011-10-30 01:00:00Z +02:00:00 standard EET
        {~N[2011-10-30 01:00:00], {7200, 0, "EET"}},
        #   2011-03-28 01:00:00Z +03:00:00 daylight EEST
        {~N[2011-03-28 01:00:00], {7200, 3600, "EEST"}},
        #   2010-10-31 01:00:00Z +02:00:00 standard EET
        {~N[2010-10-31 01:00:00], {7200, 0, "EET"}},
        #   2010-03-28 01:00:00Z +03:00:00 daylight EEST
        {~N[2010-03-28 01:00:00], {7200, 3600, "EEST"}},
        #   2009-10-25 01:00:00Z +02:00:00 standard EET
        {~N[2009-10-25 01:00:00], {7200, 0, "EET"}},
        #   2009-03-29 01:00:00Z +03:00:00 daylight EEST
        {~N[2009-03-29 01:00:00], {7200, 3600, "EEST"}},
        #   2008-10-26 01:00:00Z +02:00:00 standard EET
        {~N[2008-10-26 01:00:00], {7200, 0, "EET"}},
        #   2008-03-30 01:00:00Z +03:00:00 daylight EEST
        {~N[2008-03-30 01:00:00], {7200, 3600, "EEST"}},
        #   2007-10-28 01:00:00Z +02:00:00 standard EET
        {~N[2007-10-28 01:00:00], {7200, 0, "EET"}},
        #   2007-03-25 01:00:00Z +03:00:00 daylight EEST
        {~N[2007-03-25 01:00:00], {7200, 3600, "EEST"}},
        #   2006-10-28 23:00:00Z +02:00:00 standard EET
        {~N[2006-10-28 23:00:00], {7200, 0, "EET"}}
      ],
      [
        #   1985-04-19 23:00:00Z +03:00:00 daylight EEST
        {~N[1985-04-19 23:00:00], {7200, 3600, "EEST"}},
        #   1984-10-31 23:00:00Z +02:00:00 standard EET
        {~N[1984-10-31 23:00:00], {7200, 0, "EET"}},
        #   1983-10-01 22:00:00Z +03:00:00 standard +03
        {~N[1983-10-01 22:00:00], {10800, 0, "+03"}},
        #   1983-07-30 23:00:00Z +04:00:00 daylight +04
        {~N[1983-07-30 23:00:00], {10800, 3600, "+04"}},
        #   1978-06-28 21:00:00Z +03:00:00 standard +03
        {~N[1978-06-28 21:00:00], {10800, 0, "+03"}},
        #   1978-04-02 00:00:00Z +03:00:00 daylight EEST
        {~N[1978-04-02 00:00:00], {7200, 3600, "EEST"}},
        #   1977-10-15 23:00:00Z +02:00:00 standard EET
        {~N[1977-10-15 23:00:00], {7200, 0, "EET"}}
      ],
      [
        #   1916-04-30 22:00:00Z +03:00:00 daylight EEST
        {~N[1916-04-30 22:00:00], {7200, 3600, "EEST"}},
        #   1910-09-30 22:03:04Z +02:00:00 standard EET
        {~N[1910-09-30 22:03:04], {7200, 0, "EET"}},
        #   1879-12-31 22:04:08Z +01:56:56 standard IMT
        {~N[1879-12-31 22:04:08], {7016, 0, "IMT"}},
        #   Initially:           +01:55:52 standard LMT
        {~N[0000-01-01 00:00:00], {6952, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/London" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1997-10-26 01:00:00Z +00:00:00 standard GMT
        {~N[1997-10-26 01:00:00], {0, 0, "GMT"}},
        #   1997-03-30 01:00:00Z +01:00:00 daylight BST
        {~N[1997-03-30 01:00:00], {0, 3600, "BST"}},
        #   1996-10-27 01:00:00Z +00:00:00 standard GMT
        {~N[1996-10-27 01:00:00], {0, 0, "GMT"}},
        #   1996-03-31 01:00:00Z +01:00:00 daylight BST
        {~N[1996-03-31 01:00:00], {0, 3600, "BST"}},
        #   1995-10-22 01:00:00Z +00:00:00 standard GMT
        {~N[1995-10-22 01:00:00], {0, 0, "GMT"}},
        #   1995-03-26 01:00:00Z +01:00:00 daylight BST
        {~N[1995-03-26 01:00:00], {0, 3600, "BST"}}
      ],
      [
        #   1973-03-18 02:00:00Z +01:00:00 daylight BST
        {~N[1973-03-18 02:00:00], {0, 3600, "BST"}},
        #   1972-10-29 02:00:00Z +00:00:00 standard GMT
        {~N[1972-10-29 02:00:00], {0, 0, "GMT"}},
        #   1972-03-19 02:00:00Z +01:00:00 daylight BST
        {~N[1972-03-19 02:00:00], {0, 3600, "BST"}},
        #   1971-10-31 02:00:00Z +00:00:00 standard GMT
        {~N[1971-10-31 02:00:00], {0, 0, "GMT"}},
        #   1968-10-26 23:00:00Z +01:00:00 standard BST
        {~N[1968-10-26 23:00:00], {3600, 0, "BST"}},
        #   1968-02-18 02:00:00Z +01:00:00 daylight BST
        {~N[1968-02-18 02:00:00], {0, 3600, "BST"}}
      ],
      [
        #   1916-10-01 02:00:00Z +00:00:00 standard GMT
        {~N[1916-10-01 02:00:00], {0, 0, "GMT"}},
        #   1916-05-21 02:00:00Z +01:00:00 daylight BST
        {~N[1916-05-21 02:00:00], {0, 3600, "BST"}},
        #   1847-12-01 00:01:15Z +00:00:00 standard GMT
        {~N[1847-12-01 00:01:15], {0, 0, "GMT"}},
        #   Initially:           -00:01:15 standard LMT
        {~N[0000-01-01 00:00:00], {-75, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Luxembourg" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-10-31 01:00:00], {3600, "EU", {:template, "CE%sT"}}},
        #   2021-03-28 01:00:00Z +02:00:00 daylight CEST
        {~N[2021-03-28 01:00:00], {3600, 3600, "CEST"}},
        #   2020-10-25 01:00:00Z +01:00:00 standard CET
        {~N[2020-10-25 01:00:00], {3600, 0, "CET"}},
        #   2020-03-29 01:00:00Z +02:00:00 daylight CEST
        {~N[2020-03-29 01:00:00], {3600, 3600, "CEST"}}
      ],
      [
        #   1943-10-04 01:00:00Z +01:00:00 standard WET
        {~N[1943-10-04 01:00:00], {3600, 0, "WET"}},
        #   1943-03-29 01:00:00Z +02:00:00 daylight WEST
        {~N[1943-03-29 01:00:00], {3600, 3600, "WEST"}},
        #   1942-11-02 01:00:00Z +01:00:00 standard WET
        {~N[1942-11-02 01:00:00], {3600, 0, "WET"}},
        #   1940-05-14 02:00:00Z +02:00:00 daylight WEST
        {~N[1940-05-14 02:00:00], {3600, 3600, "WEST"}},
        #   1940-02-25 02:00:00Z +01:00:00 daylight WEST
        {~N[1940-02-25 02:00:00], {0, 3600, "WEST"}},
        #   1939-11-19 02:00:00Z +00:00:00 standard WET
        {~N[1939-11-19 02:00:00], {0, 0, "WET"}}
      ],
      [
        #   1916-09-30 23:00:00Z +01:00:00 standard CET
        {~N[1916-09-30 23:00:00], {3600, 0, "CET"}},
        #   1916-05-14 22:00:00Z +02:00:00 daylight CEST
        {~N[1916-05-14 22:00:00], {3600, 3600, "CEST"}},
        #   1904-05-31 23:35:24Z +01:00:00 standard CET
        {~N[1904-05-31 23:35:24], {3600, 0, "CET"}},
        #   Initially:           +00:24:36 standard LMT
        {~N[0000-01-01 00:00:00], {1476, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Oslo" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   1944-04-03 01:00:00Z +02:00:00 daylight CEST
        {~N[1944-04-03 01:00:00], {3600, 3600, "CEST"}},
        #   1943-10-04 01:00:00Z +01:00:00 standard CET
        {~N[1943-10-04 01:00:00], {3600, 0, "CET"}},
        #   1943-03-29 01:00:00Z +02:00:00 daylight CEST
        {~N[1943-03-29 01:00:00], {3600, 3600, "CEST"}},
        #   1942-11-02 01:00:00Z +01:00:00 standard CET
        {~N[1942-11-02 01:00:00], {3600, 0, "CET"}},
        #   1940-08-10 22:00:00Z +02:00:00 daylight CEST
        {~N[1940-08-10 22:00:00], {3600, 3600, "CEST"}},
        #   1916-09-29 22:00:00Z +01:00:00 standard CET
        {~N[1916-09-29 22:00:00], {3600, 0, "CET"}},
        #   1916-05-22 00:00:00Z +02:00:00 daylight CEST
        {~N[1916-05-22 00:00:00], {3600, 3600, "CEST"}},
        #   1894-12-31 23:17:00Z +01:00:00 standard CET
        {~N[1894-12-31 23:17:00], {3600, 0, "CET"}},
        #   Initially:           +00:43:00 standard LMT
        {~N[0000-01-01 00:00:00], {2580, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Vienna" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-10-31 01:00:00], {3600, "EU", {:template, "CE%sT"}}},
        {~N[2021-03-28 01:00:00], {3600, 3600, "CEST"}},
        {~N[2020-10-25 01:00:00], {3600, 0, "CET"}},
        {~N[2020-03-29 01:00:00], {3600, 3600, "CEST"}}
      ],
      [
        {~N[1947-10-05 01:00:00], {3600, 0, "CET"}},
        {~N[1947-04-06 01:00:00], {3600, 3600, "CEST"}},
        {~N[1946-10-07 01:00:00], {3600, 0, "CET"}},
        {~N[1946-04-14 01:00:00], {3600, 3600, "CEST"}},
        {~N[1945-04-12 01:00:00], {3600, 0, "CET"}},
        {~N[1945-04-02 01:00:00], {3600, 3600, "CEST"}},
        {~N[1944-10-02 01:00:00], {3600, 0, "CET"}},
        {~N[1944-04-03 01:00:00], {3600, 3600, "CEST"}}
      ],
      [
        {~N[1916-09-30 23:00:00], {3600, 0, "CET"}},
        {~N[1916-04-30 22:00:00], {3600, 3600, "CEST"}},
        {~N[1893-03-31 22:54:39], {3600, 0, "CET"}},
        {~N[0000-01-01 00:00:00], {3921, 0, "LMT"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Europe/Vilnius" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        #   2004-03-28 01:00:00Z +03:00:00 daylight EEST
        {~N[2004-03-28 01:00:00], {7200, 3600, "EEST"}},
        #   2003-10-26 01:00:00Z +02:00:00 standard EET
        {~N[2003-10-26 01:00:00], {7200, 0, "EET"}},
        #   2003-03-30 01:00:00Z +03:00:00 daylight EEST
        {~N[2003-03-30 01:00:00], {7200, 3600, "EEST"}},
        #   1999-10-31 01:00:00Z +02:00:00 standard EET
        {~N[1999-10-31 01:00:00], {7200, 0, "EET"}},
        #   1999-03-28 01:00:00Z +02:00:00 daylight CEST
        {~N[1999-03-28 01:00:00], {3600, 3600, "CEST"}},
        #   1998-10-25 01:00:00Z +01:00:00 standard CET
        {~N[1998-10-25 01:00:00], {3600, 0, "CET"}}
      ]
    ])
  end

  defp assert_time_zone(time_zones, "Pacific/Auckland" = tz) do
    assert_time_zone(time_zones, tz, [
      [
        {~N[2021-09-25 14:00:00], {43200, "NZ", {:template, "NZ%sT"}}},
        {~N[2021-04-03 14:00:00], {43200, 0, "NZST"}},
        {~N[2020-09-26 14:00:00], {43200, 3600, "NZDT"}},
        {~N[2020-04-04 14:00:00], {43200, 0, "NZST"}}
      ],
      [
        # 1975-02-22 14:00:00Z +12:00:00 standard NZST
        {~N[1975-02-22 14:00:00], {43200, 0, "NZST"}},
        # 1974-11-02 14:00:00Z +13:00:00 daylight NZDT
        {~N[1974-11-02 14:00:00], {43200, 3600, "NZDT"}},
        # 1945-12-31 12:00:00Z +12:00:00 standard NZST
        {~N[1945-12-31 12:00:00], {43200, 0, "NZST"}},
        # 1940-09-28 14:30:00Z +12:00:00 daylight NZST
        {~N[1940-09-28 14:30:00], {41400, 1800, "NZST"}},
        # 1940-04-27 14:00:00Z +11:30:00 standard NZMT
        {~N[1940-04-27 14:00:00], {41400, 0, "NZMT"}}
      ],
      [
        {~N[1927-11-05 14:30:00], {41400, 3600, "NZST"}},
        {~N[1868-11-01 12:20:56], {41400, 0, "NZMT"}},
        {~N[0000-01-01 00:00:00], {41944, 0, "LMT"}}
      ]
    ])
  end

  defp parse(path, file) do
    with {:ok, data} <- path |> data(file) |> IanaParser.parse(), do: data
  end

  defp parse_extract(name) do
    path = "test/fixtures/iana/2019c/extract"
    parse(path, [name])
  end

  defp data(path, files) do
    files
    |> Enum.map(fn file -> path |> Path.join(file) |> File.read!() end)
    |> Enum.join("\n")
  end

  defp to_naive(data) do
    Enum.map(data, fn {ts, info} ->
      {
        ts |> :calendar.gregorian_seconds_to_datetime() |> NaiveDateTime.from_erl!(),
        info
      }
    end)
  end

  defp assert_time_zone(time_zone) do
    time_zone
    |> parse_extract()
    |> Transformer.transform("extract_2019c", lookahead: 1)
    |> assert_time_zone(time_zone)
  end

  defp assert_time_zone(time_zones, time_zone, [item | _] = expected) when is_list(item) do
    time_zones
    |> get_in([:time_zones, time_zone])
    |> to_naive()
    |> IO.inspect(limit: :infinity, label: :test)
    |> assert_sequences(expected)
  end

  defp assert_time_zone(time_zones, time_zone, expected) do
    assert time_zones
           |> get_in([:time_zones, time_zone])
           |> to_naive() == expected
  end

  defp assert_sequences(data, sequences) do
    Enum.each(sequences, fn sequence -> assert_sequence(data, sequence) end)
  end

  defp assert_sequence(data, [element | _] = elements) do
    index =
      case Enum.find_index(data, fn x -> x == element end) do
        nil -> flunk("can't find #{inspect(element)} in #{inspect(data)}")
        index -> index
      end

    amount = length(elements)

    assert Enum.slice(data, index, amount) == elements
  end

  defp read_tzvalidate do
    content =
      File.read!("test/fixtures/iana/2019c/tzvalidate.txt")
      |> String.split("\n")

    content |> length |> IO.inspect()
    Enum.take(content, 10) |> IO.inspect()

    Enum.reduce(content, {%{}, nil}, fn
      "", {map, _} ->
        {map, nil}

      time_zone, {map, nil} ->
        {Map.put(map, time_zone, []), time_zone}

      line, {map, time_zone} ->
        lines = Map.get(map, time_zone)
        {Map.put(map, time_zone, [line | lines]), time_zone}
    end)
    |> elem(0)
    |> Enum.into(%{}, fn {time_zone, transitions} ->
      transitions =
        Enum.map(transitions, fn transition ->
          transition = String.split(transition)

          transition =
            case length(transition) do
              4 ->
                {
                  0,
                  time_to_seconds(Enum.at(transition, 1)),
                  Enum.at(transition, 2) == "daylight",
                  Enum.at(transition, 3)
                }

              5 ->
                datetime =
                  transition
                  |> Enum.take(2)
                  |> Enum.join(" ")
                  |> NaiveDateTime.from_iso8601!()
                  |> NaiveDateTimeUtil.to_gregorian_seconds()

                {
                  datetime,
                  time_to_seconds(Enum.at(transition, 2)),
                  Enum.at(transition, 3) == "daylight",
                  Enum.at(transition, 4)
                }
            end
        end)

      {time_zone, transitions}
    end)
    |> IO.inspect(label: :tzvalidate)
  end

  defp time_to_seconds("+" <> time), do: time_to_seconds(time)

  defp time_to_seconds("-" <> time), do: time_to_seconds(time) * -1

  defp time_to_seconds(time) do
    [hours, minutes, seconds] =
      time
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)

    hours * 3600 + minutes * 60 + seconds
  end

  defp get_time_zone(data, time_zone, link \\ false) do
    data
    |> Map.fetch!(:time_zones)
    |> Map.fetch(time_zone)
    |> case do
      {:ok, _} = transitions ->
        transitions

      :error ->
        case link do
          true ->
            :error

          false ->
            link = get_in(data, [:links, time_zone])
            get_time_zone(data, link, true)
        end
    end
  end
end
