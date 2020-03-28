defmodule TimeZoneInfo.Downloader.MintTest do
  use ExUnit.Case

  alias TimeZoneInfo.Downloader.Mint

  describe "get/1" do
    test "todo" do
      # uri = URI.parse("https://data.iana.org/time-zones/tzdata-latest.tar.gz")
      uri = URI.parse("http://localhost:1234/iana/2019c.tar.gz")

      opts = [
        headers: [
          {"content-type", "application/x-gzip"}
        ]
      ]

      assert {:ok, body} = Mint.download(uri, opts)
      assert byte_size(body) == 392_087
    end
  end
end
