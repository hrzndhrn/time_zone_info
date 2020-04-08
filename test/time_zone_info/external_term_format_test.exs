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
        {60_475_255_200, {0, 3600, "BST"}},
        {58_314_556_875, {0, 0, "GMT"}},
        {0, {-75, 0, "LMT"}}
      ]
    }
  }

  @binary <<131, 80, 0, 0, 1, 208, 120, 218, 149, 80, 177, 78, 195, 48, 16, 189, 196, 9, 149, 42,
            181, 84, 136, 159, 96, 162, 176, 177, 34, 85, 21, 168, 153, 26, 230, 200, 141, 175,
            114, 82, 215, 70, 137, 3, 42, 59, 59, 18, 35, 11, 63, 193, 87, 48, 177, 242, 25, 252,
            64, 240, 185, 1, 21, 169, 11, 139, 207, 126, 239, 222, 189, 231, 179, 0, 16, 9, 136,
            85, 161, 87, 181, 117, 15, 182, 118, 199, 225, 164, 169, 204, 45, 158, 78, 27, 172,
            116, 141, 27, 194, 6, 29, 54, 51, 90, 24, 77, 200, 81, 135, 92, 213, 10, 51, 179, 204,
            18, 174, 247, 55, 254, 32, 215, 88, 237, 29, 230, 252, 171, 70, 161, 247, 15, 136, 14,
            39, 55, 138, 138, 140, 36, 227, 125, 186, 6, 50, 20, 48, 82, 188, 182, 153, 224, 27,
            114, 187, 71, 92, 241, 94, 233, 26, 2, 14, 28, 4, 176, 198, 230, 190, 234, 66, 121,
            33, 251, 135, 112, 1, 48, 28, 145, 117, 48, 47, 5, 244, 109, 177, 198, 236, 193, 232,
            157, 76, 127, 35, 211, 232, 72, 134, 58, 134, 167, 229, 215, 231, 208, 13, 131, 46,
            56, 249, 29, 228, 210, 20, 57, 250, 63, 16, 204, 166, 73, 234, 235, 229, 60, 45, 189,
            234, 245, 228, 229, 216, 171, 126, 141, 137, 243, 212, 251, 227, 199, 243, 128, 168,
            237, 72, 210, 202, 144, 131, 100, 139, 182, 109, 223, 58, 112, 150, 164, 46, 103, 239,
            206, 109, 180, 216, 46, 57, 62, 31, 159, 93, 228, 223, 198, 195, 120, 242>>

  describe "encode/1" do
    test "encodes data" do
      assert ExternalTermFormat.encode(@term) == {:ok, @binary}
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
  end

  describe "decode/1" do
    test "decodes binary" do
      assert ExternalTermFormat.decode(@binary) == {:ok, @term}
    end
  end
end
