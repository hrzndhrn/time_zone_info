defmodule TimeZoneInfo.IanaParserTest do
  use ExUnit.Case

  alias TimeZoneInfo.IanaParser

  @empty %{}

  describe "parse comment" do
    test "sign" do
      data = "#\n"

      assert IanaParser.parse(data) == {:ok, @empty}
    end

    test "single line" do
      data = "# comment"

      assert IanaParser.parse(data) == {:ok, @empty}
    end

    test "multiple lines" do
      data = """
      # comment 1
      #
      # comment 2
      """

      assert IanaParser.parse(data) == {:ok, @empty}
    end

    test "multiple lines with \\r\\n" do
      data = "# comment 1 \r\n\r\n# comment 2"

      assert IanaParser.parse(data) == {:ok, @empty}
    end
  end

  describe "parse invalid input" do
    test "rule error" do
      data = "Rule 1 1 1 error"

      assert IanaParser.parse(data) == {:error, "Rule 1 1 1 error", 1, 0}
    end
  end

  describe "parse rules" do
    test "Germany" do
      data = """
      # Rule	NAME	FROM	TO	TYPE	IN	ON	AT	SAVE	LETTER/S
      Rule	Germany	1946	only	-	Apr	14	2:00s	1:00	S
      Rule	Germany	1946	only	-	Oct	 7	2:00s	0	-
      Rule	Germany	1947	1949	-	Oct	Sun>=1	2:00s	0	-
      # http://www.ptb.de/de/org/4/44/441/salt.htm says the following transition
      # occurred at 3:00 MEZ, not the 2:00 MEZ given in Shanks & Pottenger.
      # Go with the PTB.
      Rule	Germany	1947	only	-	Apr	 6	3:00s	1:00	S
      Rule	Germany	1947	only	-	May	11	2:00s	2:00	M
      Rule	Germany	1947	only	-	Jun	29	3:00	1:00	S
      Rule	Germany	1948	only	-	Apr	18	2:00s	1:00	S
      Rule	Germany	1949	only	-	Apr	10	2:00s	1:00	S
      """

      expected = [
        [
          {:from, 1946},
          {:to, :only},
          {:in, 4},
          {:on, 14},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 3600},
          {:letters, "S"}
        ],
        [
          {:from, 1946},
          {:to, :only},
          {:in, 10},
          {:on, 7},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 0},
          {:letters, nil}
        ],
        [
          {:from, 1947},
          {:to, 1949},
          {:in, 10},
          {:on, [day: 1, op: :ge, day_of_week: 7]},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 0},
          {:letters, nil}
        ],
        [
          {:from, 1947},
          {:to, :only},
          {:in, 4},
          {:on, 6},
          {:at, {3, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 3600},
          {:letters, "S"}
        ],
        [
          {:from, 1947},
          {:to, :only},
          {:in, 5},
          {:on, 11},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 7200},
          {:letters, "M"}
        ],
        [
          {:from, 1947},
          {:to, :only},
          {:in, 6},
          {:on, 29},
          {:at, {3, 0, 0}},
          {:time_standard, :wall},
          {:std_offset, 3600},
          {:letters, "S"}
        ],
        [
          {:from, 1948},
          {:to, :only},
          {:in, 4},
          {:on, 18},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 3600},
          {:letters, "S"}
        ],
        [
          {:from, 1949},
          {:to, :only},
          {:in, 4},
          {:on, 10},
          {:at, {2, 0, 0}},
          {:time_standard, :standard},
          {:std_offset, 3600},
          {:letters, "S"}
        ]
      ]

      assert {:ok, %{rules: rules}} = IanaParser.parse(data)
      assert Map.get(rules, "Germany") == expected
    end

    test "EU" do
      data = """
      # Rule	NAME	FROM	TO	TYPE	IN	ON	AT	SAVE	LETTER/S
      Rule	EU	1977	1980	-	Apr	Sun>=1	 1:00u	1:00	S
      Rule	EU	1977	only	-	Sep	lastSun	 1:00u	0	-
      Rule	EU	1978	only	-	Oct	 1	 1:00u	0	-
      Rule	EU	1979	1995	-	Sep	lastSun	 1:00u	0	-
      Rule	EU	1981	max	-	Mar	lastSun	 1:00u	1:00	S
      Rule	EU	1996	max	-	Oct	lastSun	 1:00u	0	-
      """

      expected = [
        [
          from: 1977,
          to: 1980,
          in: 4,
          on: [day: 1, op: :ge, day_of_week: 7],
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 3600,
          letters: "S"
        ],
        [
          from: 1977,
          to: :only,
          in: 9,
          on: [last_day_of_week: 7],
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 0,
          letters: nil
        ],
        [
          from: 1978,
          to: :only,
          in: 10,
          on: 1,
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 0,
          letters: nil
        ],
        [
          from: 1979,
          to: 1995,
          in: 9,
          on: [last_day_of_week: 7],
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 0,
          letters: nil
        ],
        [
          from: 1981,
          to: :max,
          in: 3,
          on: [last_day_of_week: 7],
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 3600,
          letters: "S"
        ],
        [
          from: 1996,
          to: :max,
          in: 10,
          on: [last_day_of_week: 7],
          at: {1, 0, 0},
          time_standard: :utc,
          std_offset: 0,
          letters: nil
        ]
      ]

      assert {:ok, %{rules: rules}} = IanaParser.parse(data)
      assert Map.get(rules, "EU") == expected
    end
  end

  describe "parse link" do
    test "multiple lines" do
      data = """
      Link	Europe/Rome	Europe/Vatican
      Link Utopia/Elixus Utopia/Erlson
      Link	Europe/Rome	Europe/San_Marino
      """

      expected = %{
        "Europe/San_Marino" => "Europe/Rome",
        "Europe/Vatican" => "Europe/Rome",
        "Utopia/Erlson" => "Utopia/Elixus"
      }

      assert {:ok, %{links: links}} = IanaParser.parse(data)
      assert links == expected
    end
  end

  describe "parse zone" do
    test "EST/MST/HST" do
      data = """
      # Zone	NAME		STDOFF	RULES	FORMAT	[UNTIL]
      Zone	EST		 -5:00	-	EST
      Zone	MST		 -7:00	-	MST
      Zone	HST		-10:00	-	HST
      """

      expected = %{
        "EST" => [
          [
            utc_offset: -18000,
            rules: nil,
            format: {:string, "EST"},
            until: nil,
            time_standard: :wall
          ]
        ],
        "HST" => [
          [
            utc_offset: -36000,
            rules: nil,
            format: {:string, "HST"},
            until: nil,
            time_standard: :wall
          ]
        ],
        "MST" => [
          [
            utc_offset: -25200,
            rules: nil,
            format: {:string, "MST"},
            until: nil,
            time_standard: :wall
          ]
        ]
      }

      assert {:ok, %{zones: zones}} = IanaParser.parse(data)
      assert zones == expected
    end

    test "Europe/Berlin" do
      data = """
      Zone	Europe/Berlin	0:53:28 -	LMT	1893 Apr # comment
      			1:00	C-Eur	CE%sT	1945 May 24  2:00
      			1:00 SovietZone	CE%sT	1946
      # comment
      			1:00	Germany	CE%sT	1980
      			1:00	EU	CE%sT
      Zone Utopia/Elixium	 0:50:20 -	LMT	1890
            1:0 Foo FF  1909 May 11 2:10:20
      			 0:00	EU	WE%sT
      """

      berlin = [
        [
          utc_offset: 3208,
          rules: nil,
          format: {:string, "LMT"},
          until: {1893, 4},
          time_standard: :wall
        ],
        [
          utc_offset: 3600,
          rules: "C-Eur",
          format: {:template, "CE%sT"},
          until: {1945, 5, 24, 2},
          time_standard: :wall
        ],
        [
          utc_offset: 3600,
          rules: "SovietZone",
          format: {:template, "CE%sT"},
          until: {1946},
          time_standard: :wall
        ],
        [
          utc_offset: 3600,
          rules: "Germany",
          format: {:template, "CE%sT"},
          until: {1980},
          time_standard: :wall
        ],
        [
          utc_offset: 3600,
          rules: "EU",
          format: {:template, "CE%sT"},
          until: nil,
          time_standard: :wall
        ]
      ]

      elexium = [
        [
          utc_offset: 3020,
          rules: nil,
          format: {:string, "LMT"},
          until: {1890},
          time_standard: :wall
        ],
        [
          utc_offset: 3600,
          rules: "Foo",
          format: {:string, "FF"},
          until: {1909, 5, 11, 2, 10, 20},
          time_standard: :wall
        ],
        [
          utc_offset: 0,
          rules: "EU",
          format: {:template, "WE%sT"},
          until: nil,
          time_standard: :wall
        ]
      ]

      assert {:ok, %{zones: zones}} = IanaParser.parse(data)
      assert Map.get(zones, "Europe/Berlin") == berlin
      assert Map.get(zones, "Utopia/Elixium") == elexium
    end

    test "Europe/Riga" do
      data = """
      # Zone	NAME		STDOFF	RULES	FORMAT	[UNTIL]
      Zone	Europe/Riga	1:36:34	-	LMT	1880
      			1:36:34	-	RMT	1918 Apr 15  2:00 # Riga MT
      			1:36:34	1:00	LST	1918 Sep 16  3:00 # Latvian ST
      			1:36:34	-	RMT	1919 Apr  1  2:00
      			1:36:34	1:00	LST	1919 May 22  3:00
      			1:36:34	-	RMT	1926 May 11
      			2:00	-	EET	1940 Aug  5
      			3:00	-	MSK	1941 Jul
      			1:00	C-Eur	CE%sT	1944 Oct 13
      			3:00	Russia	MSK/MSD	1989 Mar lastSun  2:00s
      			2:00	1:00	EEST	1989 Sep lastSun  2:00s
      			2:00	Latvia	EE%sT	1997 Jan 21
      			2:00	EU	EE%sT	2000 Feb 29
      			2:00	-	EET	2001 Jan  2
      			2:00	EU	EE%sT
      """

      assert {:ok, %{zones: zones}} = IanaParser.parse(data)
      assert zones = Map.get(zones, "Europe/Riga")

      assert Enum.at(zones, 1) ==
               [
                 utc_offset: 5794,
                 rules: nil,
                 format: {:string, "RMT"},
                 until: {1918, 4, 15, 2},
                 time_standard: :wall
               ]
    end

    test "lex" do
      data = """
      # Zone	NAME		STDOFF	RULES	FORMAT	[UNTIL]
      Zone	Utopia/Lex	1:55:52 -	LMT	1880
      			1:56:56	-	LMT	2018 Oct lastTue 1
      			2:00	Lex	L%sT	2019 Jun Sun>=7
      """

      assert {:ok, %{zones: zones}} = IanaParser.parse(data)
      assert zones = Map.get(zones, "Utopia/Lex")

      assert zones == [
               [
                 utc_offset: 6952,
                 rules: nil,
                 format: {:string, "LMT"},
                 until: {1880},
                 time_standard: :wall
               ],
               [
                 utc_offset: 7016,
                 rules: nil,
                 format: {:string, "LMT"},
                 until: {2018, 10, [last_day_of_week: 2], 1},
                 time_standard: :wall
               ],
               [
                 utc_offset: 7200,
                 rules: "Lex",
                 format: {:template, "L%sT"},
                 until: {2019, 6, [day: 7, op: :ge, day_of_week: 7]},
                 time_standard: :wall
               ]
             ]
    end

    test "istanbul" do
      data = """
      # Zone	NAME		STDOFF	RULES	FORMAT	[UNTIL]
      Zone	Europe/Istanbul	1:55:52 -	LMT	1880
      			1:56:56	-	IMT	1910 Oct # Istanbul Mean Time?
      			2:00	Turkey	EE%sT	1978 Jun 29
      			3:00	Turkey	+03/+04	1984 Nov  1  2:00
      			2:00	Turkey	EE%sT	2007
      			2:00	EU	EE%sT	2011 Mar 27  1:00u
      			2:00	-	EET	2011 Mar 28  1:00u
      			2:00	EU	EE%sT	2014 Mar 30  1:00u
      			2:00	-	EET	2014 Mar 31  1:00u
      			2:00	EU	EE%sT	2015 Oct 25  1:00u
      			2:00	1:00	EEST	2015 Nov  8  1:00u
      			2:00	EU	EE%sT	2016 Sep  7
      			3:00	-	+03
      """

      assert {:ok, %{zones: zones}} = IanaParser.parse(data)
      assert zones = Map.get(zones, "Europe/Istanbul")

      assert Enum.at(zones, 3) == [
               utc_offset: 10800,
               rules: "Turkey",
               format: {:choice, ["+03", "+04"]},
               until: {1984, 11, 1, 2},
               time_standard: :wall
             ]

      assert hd(zones) == [
               utc_offset: 6952,
               rules: nil,
               format: {:string, "LMT"},
               until: {1880},
               time_standard: :wall
             ]
    end
  end

  describe("parse iana file") do
    setup do
      %{path: "test/fixtures/iana/2019c"}
    end

    test "africa", %{path: path} do
      data = path |> Path.join("africa") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 23
      assert map_size(parsed.rules) == 10
      assert map_size(parsed.links) == 36

      assert all_rules(parsed) == 294
    end

    test "antarctica", %{path: path} do
      data = path |> Path.join("antarctica") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 9
      assert map_size(parsed.rules) == 1
      refute Map.has_key?(parsed, :links)

      assert all_rules(parsed) == 2
    end

    test "asia", %{path: path} do
      data = path |> Path.join("asia") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 61
      assert map_size(parsed.links) == 7
      assert map_size(parsed.rules) == 27

      assert all_rules(parsed) == 463
    end

    test "australasia", %{path: path} do
      data = path |> Path.join("australasia") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 48
      assert map_size(parsed.links) == 3
      assert map_size(parsed.rules) == 18

      assert all_rules(parsed) == 174
    end

    test "europe", %{path: path} do
      data = path |> Path.join("europe") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 78
      assert map_size(parsed.links) == 16
      assert map_size(parsed.rules) == 35

      assert all_rules(parsed) == 596
    end

    test "northamerica", %{path: path} do
      data = path |> Path.join("northamerica") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 93
      assert map_size(parsed.links) == 1
      assert map_size(parsed.rules) == 38

      assert all_rules(parsed) == 375
    end

    test "southamerica", %{path: path} do
      data = path |> Path.join("southamerica") |> File.read!()

      assert {:ok, parsed} = IanaParser.parse(data)

      assert map_size(parsed.zones) == 47
      assert map_size(parsed.links) == 16
      assert map_size(parsed.rules) == 10

      assert all_rules(parsed) == 218
    end
  end

  defp all_rules(data) do
    Enum.reduce(data.rules, 0, fn {_, rules}, acc -> acc + length(rules) end)
  end
end
