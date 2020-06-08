defmodule TimeZoneInfo.FileArchiveTest do
  use ExUnit.Case, async: true

  alias TimeZoneInfo.FileArchive

  setup do
    archive = File.read!("test/fixtures/iana/tzdata2019c.tar.gz")
    %{archive: archive}
  end

  describe "extract/2" do
    test "reads version file", %{archive: archive} do
      assert FileArchive.extract(archive, ["version"]) ==
               {:ok, %{"version" => "2019c\n"}}
    end

    test "reads files", %{archive: archive} do
      file_names = ["asia", "europe", "southamerica"]
      assert {:ok, files} = FileArchive.extract(archive, file_names)
      assert files |> Map.keys() |> Enum.sort() == file_names
      assert Regex.match?(~r/^Zone.*Europe.Berlin/m, Map.get(files, "europe"))
      assert Regex.match?(~r/^Zone.*Asia.Shanghai/m, Map.get(files, "asia"))
      assert Regex.match?(~r/^Zone.*America.Belem/m, Map.get(files, "southamerica"))
    end

    test "returns error for invalid archive" do
      assert FileArchive.extract("invalid", ["version"]) == {:error, :eof}
    end

    test "returns error if files are not available", %{archive: archive} do
      assert FileArchive.extract(archive, ["version", "foo", "bar"]) ==
               {:error, {:not_found, ["foo", "bar"]}}
    end
  end
end
