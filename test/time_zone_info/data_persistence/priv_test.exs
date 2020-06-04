defmodule TimeZoneInfo.DataPersistence.PrivTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.DataPersistence.Priv
  alias TimeZoneInfo.{ExternalTermFormat, IanaParser, Transformer}

  @path "test/data.etf"
  @fixture "data/2019c/extract/africa/data.etf"

  @london "test/fixtures/iana/2019c/extract/Europe/London"
  @config [
    files: ["london"],
    time_zones: :all,
    lookahead: 15
  ]

  setup_all do
    content = File.read!(@london)

    data =
      with {:ok, parsed} <- IanaParser.parse(content) do
        Transformer.transform(parsed, "2019c", @config)
      end

    %{data: data}
  end

  setup do
    cp_data(@fixture, @path)
    put_env(priv: [path: @path])

    on_exit(fn ->
      rm_data(@path)
      delete_env()
    end)
  end

  describe "put/1" do
    test "writes data to file", %{data: data} do
      assert Priv.put(data) == :ok
      assert data_exists?(@path)
    end

    test "returns an error tuple if the dir is unavailable", %{data: data} do
      rm_data(@path)
      assert Priv.put(data) == {:error, :enoent}
    end

    test "returns an error tuple if the config is unavailable", %{data: data} do
      delete_env()
      assert Priv.put(data) == {:error, {:invalid_config, :priv}}
    end

    test "returns an error tuple if the config is invalid", %{data: data} do
      put_env(priv: [foo: "42"])
      assert Priv.put(data) == {:error, {:invalid_config, [:priv, :path]}}
    end

    test "returns an error tuple if the path is invalid", %{data: data} do
      put_env(priv: [path: 42])
      assert Priv.put(data) == {:error, {:invalid_config, [{:priv, [path: 42]}]}}
    end
  end

  describe "fetch/0" do
    test "returns data", %{data: data} do
      assert Priv.put(data) == :ok
      assert Priv.fetch() == {:ok, data}
    end

    test "returns error if the data is unavalable" do
      rm_data(@path)
      assert Priv.fetch() == {:error, :enoent}
    end
  end

  describe "checksum/0" do
    test "returns the checksum for the data", %{data: data} do
      assert Priv.put(data) == :ok
      assert Priv.checksum() == ExternalTermFormat.checksum(data)
    end

    test "returns error if the data is unavalable" do
      rm_data(@path)
      assert Priv.checksum() == {:error, :enoent}
    end
  end

  describe "fetch_last_update/0" do
    test "returns the checksum for the data", %{data: data} do
      assert Priv.put(data) == :ok
      assert {:ok, timestamp} = Priv.fetch_last_update()
      assert_in_delta(timestamp, now(), 3)
    end

    test "returns error if the data is unavalable" do
      rm_data(@path)
      assert Priv.fetch_last_update() == {:error, :enoent}
    end
  end
end
