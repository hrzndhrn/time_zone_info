defmodule TimeZoneInfo.DownloaderTest do
  use ExUnit.Case

  import Mox
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.Downloader
  alias TimeZoneInfo.DownloaderMock

  setup do
    on_exit(&delete_env/0)
  end

  setup :verify_on_exit!

  test "download/1" do
    env =
      put_env(
        downloader: [
          module: DownloaderMock,
          mode: :etf,
          uri: "http://localhost:123/data.etf",
          headers: [
            {"Content-Type", "application/tar+gzip"},
            {"User-Agent", "Elixir.TimeZoneInfo.Mint"}
          ]
        ]
      )

    expect(DownloaderMock, :download, fn uri, opts ->
      assert uri == URI.parse(env[:downloader][:uri])

      assert opts ==
               env
               |> Keyword.fetch!(:downloader)
               |> Keyword.delete(:module)
               |> Keyword.delete(:uri)
    end)

    assert Downloader.download([])
  end

  test "returns error tuple if config is unavailable" do
    delete_env()
    assert Downloader.download([]) == {:error, {:invalid_config, :downloader}}
  end
end
