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
        {{10, [last_day_of_week: 7], 1, 0, 0}, :utc, 0, nil},
        {{3, [last_day_of_week: 7], 1, 0, 0}, :utc, 3600, "S"}
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

  @binary <<131, 80, 0, 0, 1, 204, 120, 218, 141, 80, 61, 78, 195, 48, 20, 126, 137, 19, 42, 85,
            106, 169, 16, 151, 96, 162, 176, 177, 34, 85, 21, 168, 153, 26, 230, 232, 53, 118,
            229, 164, 174, 141, 18, 7, 84, 118, 118, 36, 70, 22, 46, 193, 41, 152, 88, 57, 6, 23,
            8, 126, 110, 64, 69, 234, 192, 226, 103, 127, 159, 191, 31, 61, 11, 0, 17, 135, 88,
            21, 122, 85, 91, 247, 96, 107, 119, 28, 78, 154, 202, 220, 138, 211, 105, 35, 42, 93,
            139, 13, 97, 131, 14, 155, 25, 205, 141, 38, 228, 168, 67, 174, 106, 37, 50, 179, 204,
            18, 212, 251, 63, 254, 32, 215, 162, 218, 107, 230, 242, 171, 70, 9, 159, 31, 16, 29,
            78, 110, 20, 13, 25, 201, 24, 251, 116, 13, 100, 200, 97, 164, 176, 182, 25, 199, 13,
            165, 221, 11, 177, 194, 94, 137, 1, 2, 2, 7, 214, 216, 220, 79, 93, 40, 47, 99, 255,
            150, 45, 0, 134, 35, 138, 13, 230, 37, 135, 190, 45, 214, 34, 123, 48, 122, 167, 207,
            223, 186, 100, 28, 201, 80, 199, 240, 180, 252, 250, 28, 74, 134, 208, 149, 166, 180,
            131, 92, 154, 34, 23, 190, 63, 193, 108, 154, 164, 126, 94, 206, 211, 210, 171, 94,
            79, 94, 142, 189, 234, 55, 152, 56, 79, 189, 63, 126, 60, 15, 136, 218, 90, 146, 86,
            134, 8, 146, 45, 218, 182, 125, 235, 192, 89, 146, 186, 158, 189, 59, 183, 205, 98,
            187, 224, 248, 124, 124, 118, 145, 127, 3, 11, 157, 120, 32>>

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
