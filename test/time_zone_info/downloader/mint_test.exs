defmodule TimeZoneInfo.Downloader.MintTest do
  use ExUnit.Case

  alias TimeZoneInfo.Downloader.Mint

  describe "get/1" do
    test "returns data" do
      # uri = URI.parse("https://data.iana.org/time-zones/tzdata-latest.tar.gz")
      uri = URI.parse("http://localhost:1234/fixtures/iana/tzdata2019c.tar.gz")

      opts = [
        headers: [
          {"content-type", "application/gzip"}
        ]
      ]

      assert {:ok, {200, body}} = Mint.download(uri, opts)
      assert byte_size(body) == 392_087
    end

    test "returns 404" do
      uri = URI.parse("http://localhost:1234/missing")

      opts = [
        headers: [
          {"content-type", "application/gzip"}
        ]
      ]

      assert {:ok, {404, "Not Found"}} = Mint.download(uri, opts)
    end
  end
end
