defmodule TimeZoneInfo.ExternalTermFormatTest do
  use ExUnit.Case, async: true

  alias TimeZoneInfo.ExternalTermFormat

  @term %{
    version: "2019c",
    links: %{
      "Europe/Guernsey" => "Europe/London",
      "Europe/Isle_of_Man" => "Europe/London",
      "Europe/Jersey" => "Europe/London"
    },
    rules: %{
      "EU" => [
        {{10, [last_day_of_week: 7], {1, 0, 0}}, :utc, 0, nil},
        {{3, [last_day_of_week: 7], {1, 0, 0}}, :utc, 3600, "S"}
      ]
    },
    time_zones: %{
      "Europe/London" => [
        {63_802_861_200, {0, "EU", {:choice, ["GMT", "BST"]}}},
        {60_475_255_200, {0, 3600, "BST", {~N[1916-05-21 03:00:00], ~N[1916-10-01 03:00:00]}}},
        {58_314_556_875, {0, 0, "GMT", {~N[1847-12-01 00:01:15], ~N[1916-05-21 02:00:00]}}},
        {0, {-75, 0, "LMT", {:min, ~N[1847-12-01 00:00:00]}}}
      ]
    },
    config: [
      lookahead: 1,
      files: ["europe"],
      time_zones: [
        "Europe/Guernsey",
        "Europe/Isle_of_Man",
        "Europe/Jersey",
        "Europe/London"
      ]
    ]
  }

  @binary <<131, 80, 0, 0, 5, 129, 120, 218, 197, 148, 203, 110, 212, 48, 20, 134, 79, 110, 51,
            116, 160, 211, 10, 202, 67, 176, 41, 151, 77, 197, 22, 58, 170, 138, 90, 88, 204, 176,
            142, 78, 99, 15, 118, 198, 177, 145, 227, 20, 6, 177, 237, 190, 18, 75, 54, 188, 4,
            79, 193, 138, 45, 143, 193, 11, 12, 62, 78, 58, 237, 72, 20, 168, 160, 98, 147, 196,
            231, 226, 255, 59, 191, 147, 56, 0, 200, 24, 244, 10, 163, 167, 242, 149, 242, 171,
            68, 196, 12, 214, 148, 49, 51, 20, 28, 25, 70, 180, 206, 166, 82, 241, 154, 210, 81,
            229, 47, 61, 222, 88, 243, 154, 151, 148, 26, 56, 89, 241, 252, 157, 209, 109, 62,
            165, 252, 198, 40, 228, 239, 239, 53, 220, 234, 154, 207, 41, 118, 187, 139, 237, 215,
            138, 231, 102, 154, 31, 162, 166, 240, 122, 23, 126, 198, 109, 87, 120, 22, 57, 48,
            154, 25, 93, 150, 94, 93, 73, 61, 171, 29, 193, 93, 182, 251, 106, 211, 31, 232, 157,
            23, 254, 142, 192, 235, 219, 198, 79, 239, 206, 166, 143, 71, 47, 105, 210, 88, 164,
            34, 193, 65, 48, 133, 140, 216, 84, 88, 187, 156, 225, 156, 212, 222, 112, 62, 195,
            126, 233, 11, 34, 4, 4, 6, 73, 227, 138, 112, 215, 82, 133, 198, 228, 10, 141, 71, 0,
            195, 77, 146, 142, 198, 229, 138, 227, 75, 166, 85, 228, 112, 16, 34, 214, 25, 156,
            78, 191, 127, 27, 250, 205, 160, 3, 39, 189, 94, 33, 140, 44, 120, 152, 129, 194, 201,
            222, 225, 36, 220, 159, 140, 39, 101, 232, 250, 116, 239, 227, 214, 80, 164, 8, 75,
            97, 202, 137, 152, 228, 214, 60, 64, 158, 215, 206, 54, 133, 203, 115, 6, 91, 35, 37,
            223, 74, 187, 253, 28, 229, 49, 223, 69, 199, 39, 158, 142, 193, 141, 2, 21, 215, 12,
            45, 131, 59, 93, 197, 211, 46, 178, 189, 63, 126, 225, 231, 242, 3, 227, 93, 230, 57,
            77, 99, 49, 97, 112, 179, 146, 133, 53, 53, 247, 175, 34, 19, 113, 59, 124, 175, 146,
            186, 113, 156, 30, 179, 202, 104, 39, 144, 94, 214, 182, 134, 130, 233, 156, 163, 245,
            144, 253, 247, 255, 28, 45, 186, 50, 218, 224, 18, 180, 96, 233, 151, 147, 175, 31,
            214, 201, 210, 246, 40, 200, 243, 107, 240, 115, 9, 13, 191, 134, 142, 150, 208, 183,
            206, 161, 55, 46, 64, 239, 92, 223, 81, 199, 127, 123, 212, 212, 33, 210, 163, 197,
            98, 241, 185, 51, 243, 128, 204, 244, 58, 126, 139, 255, 102, 41, 252, 204, 210, 139,
            220, 59, 254, 211, 237, 31, 251, 159, 140, 108, 255, 59, 217, 163, 7, 15, 31, 23, 63,
            0, 107, 56, 150, 181>>

  describe "encode/1" do
    test "encodes data" do
      assert {:ok, binary} = ExternalTermFormat.encode(@term)
      assert is_binary(binary)
    end

    test "returns an error tuple for invalid data" do
      assert ExternalTermFormat.encode("foo") == {:error, :invalid_data}
    end

    test "returns an error tuple for missing key" do
      term = Map.delete(@term, :links)
      assert ExternalTermFormat.encode(term) == {:error, :invalid_keys}
    end

    test "returns an error tuple for an invalid version" do
      term = Map.put(@term, :version, 5)
      assert ExternalTermFormat.encode(term) == {:error, :invalid_version}
    end

    test "returns an error tuple for an invalid time_zones value in config" do
      term = put_in(@term, [:config, :time_zones], :foo)
      assert ExternalTermFormat.encode(term) == {:error, {:invalid_config, [time_zones: :foo]}}

      term = put_in(@term, [:config, :time_zones], [:foo])
      assert ExternalTermFormat.encode(term) == {:error, {:invalid_config, [time_zones: [:foo]]}}
    end

    test "returns an error tuple for an invalid lookahead value in config" do
      term = put_in(@term, [:config, :lookahead], 0)
      assert ExternalTermFormat.encode(term) == {:error, {:invalid_config, [lookahead: 0]}}
    end

    test "returns an error tuple for an invalid files value in config" do
      term = put_in(@term, [:config, :files], ["foo", 0])
      assert ExternalTermFormat.encode(term) == {:error, {:invalid_config, [files: ["foo", 0]]}}
    end
  end

  describe "decode/1" do
    test "decodes binary" do
      assert ExternalTermFormat.decode(@binary) == {:ok, @term}
    end

    test "return an error tuple when decode fails" do
      assert ExternalTermFormat.decode("invalid") == {:error, :decode_fails}
    end
  end

  describe "checksum/1" do
    test "returns checksum" do
      assert ExternalTermFormat.checksum(@term) == ExternalTermFormat.checksum(@binary)
    end
  end
end
