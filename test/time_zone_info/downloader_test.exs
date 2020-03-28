defmodule TimeZoneInfo.DownloaderTest do
  use ExUnit.Case

  import Mox
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{Downloader, DownloaderMock}

  @env [
    downloader: [
      module: DownloaderMock,
      format: :etf,
      uri: "http://localhost:123/data.etf",
      headers: [
        {"Content-Type", "application/tar+gzip"},
        {"User-Agent", "Elixir.TimeZoneInfo.Mint"}
      ]
    ]
  ]

  setup do
    put_env(@env)
    on_exit(&delete_env/0)
  end

  setup :verify_on_exit!

  test "download/1" do
    expect(DownloaderMock, :download, fn uri, opts ->
      assert uri == URI.parse(@env[:downloader][:uri])

      assert opts ==
               @env
               |> Keyword.fetch!(:downloader)
               |> Keyword.delete(:module)
               |> Keyword.delete(:uri)
    end)

    assert Downloader.download()
  end

  test "returns error tuple if config is unavailable" do
    delete_env()
    assert Downloader.download() == {:error, {:invalid_config, :downloader}}
  end
end
