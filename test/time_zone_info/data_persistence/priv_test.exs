defmodule TimeZoneInfo.DataPersistence.PrivTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.DataPersistence.Priv
  alias TimeZoneInfo.ExternalTermFormat
  alias TimeZoneInfo.IanaParser
  alias TimeZoneInfo.Transformer

  @path "../test/temp/#{__MODULE__}"
  @data "#{@path}/data.etf"
  @timestamp "#{@path}/timestamp.txt"

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
    cp_data(@fixture, @data)
    put_env(priv: [data: @data, timestamp: @timestamp])

    on_exit(fn ->
      delete_env()
    end)
  end

  describe "put/1" do
    test "writes data to file", %{data: data} do
      assert Priv.put(data) == :ok
      assert data_exists?(@data)
    end

    test "returns an error tuple if the dir is unavailable", %{data: data} do
      put_env(priv: [data: "#{@path}/foo/data.etf"])
      assert Priv.put(data) == {:error, :enotdir}
    end

    test "returns an error tuple if the config is unavailable", %{data: data} do
      delete_env()
      assert Priv.put(data) == {:error, {:invalid_config, :priv}}
    end

    test "returns an error tuple if the config is invalid", %{data: data} do
      put_env(priv: [foo: "42"])
      assert Priv.put(data) == {:error, {:invalid_config, [:priv, :data]}}
    end

    test "returns an error tuple if the data path is invalid", %{data: data} do
      put_env(priv: [data: 42])
      assert Priv.put(data) == {:error, {:invalid_config, [{:priv, [data: 42]}]}}
    end
  end

  describe "fetch/0" do
    test "returns data", %{data: data} do
      assert Priv.put(data) == :ok
      assert Priv.fetch() == {:ok, data}
    end

    test "returns error if the data is unavalable" do
      rm_data(@data)
      assert Priv.fetch() == {:error, :enoent}
    end
  end

  describe "checksum/0" do
    test "returns the checksum for the data", %{data: data} do
      assert Priv.put(data) == :ok
      assert Priv.checksum() == ExternalTermFormat.checksum(data)
    end

    test "returns error if the data is unavalable" do
      rm_data(@data)
      assert Priv.checksum() == {:error, :enoent}
    end
  end

  describe "fetch_last_update/0" do
    test "returns the timestamp for the last update" do
      set_priv_timestamp(@timestamp, 0)
      assert {:ok, 0} = Priv.fetch_last_update()
      assert Priv.put_last_update(333) == :ok
      assert {:ok, 333} = Priv.fetch_last_update()
    end

    test "returns error if the timestamp is unavalable" do
      put_env(priv: [timestamp: "#{@path}/no.txt"])
      assert Priv.fetch_last_update() == {:error, :enoent}
    end
  end
end
