defmodule TimeZoneInfo.DataPersistence.FileSystemTest do
  use ExUnit.Case

  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{
    DataPersistence.FileSystem,
    ExternalTermFormat,
    IanaParser,
    Transformer
  }

  @path "test/temp/data.etf"
  @data "test/fixtures/data/2019c/extract/africa/data.etf"
  @london File.read!("test/fixtures/iana/2019c/extract/Europe/London")

  setup_all do
    @path |> Path.dirname() |> File.mkdir()

    data =
      with {:ok, parsed} <- IanaParser.parse(@london) do
        Transformer.transform(parsed, "2019c")
      end

    %{data: data}
  end

  setup do
    File.cp!(@data, @path)
    put_env(file_system: [path: @path])

    on_exit(fn ->
      File.rm(@path)
      delete_env()
    end)
  end

  describe "put/1" do
    test "writes data to file", %{data: data} do
      assert FileSystem.put(data) == :ok
      assert File.exists?(@path)
    end

    test "returns an error tuple if the dir is unavailable", %{data: data} do
      put_env(file_system: [path: "test/temp/no_dir/data.etf"])
      assert FileSystem.put(data) == {:error, :enoent}
    end

    test "returns an error tuple if the config is unavailable", %{data: data} do
      delete_env()
      assert FileSystem.put(data) == {:error, {:invalid_config, :file_system}}
    end

    test "returns an error tuple if the config is invalid", %{data: data} do
      put_env(file_system: [foo: "42"])
      assert FileSystem.put(data) == {:error, {:invalid_config, [:file_system, :path]}}
    end

    test "returns an error tuple if the path is invalid", %{data: data} do
      put_env(file_system: [path: 42])
      assert FileSystem.put(data) == {:error, {:invalid_config, [{:file_system, [path: 42]}]}}
    end
  end

  describe "fetch/0" do
    test "returns data", %{data: data} do
      assert FileSystem.put(data) == :ok
      assert FileSystem.fetch() == {:ok, data}
    end

    test "returns error if the data is unavalable" do
      File.rm!(@path)
      assert FileSystem.fetch() == {:error, :enoent}
    end
  end

  describe "checksum/0" do
    test "returns the checksum for the data", %{data: data} do
      assert FileSystem.put(data) == :ok
      assert FileSystem.checksum() == ExternalTermFormat.checksum(data)
    end

    test "returns error if the data is unavalable" do
      File.rm!(@path)
      assert FileSystem.checksum() == {:error, :enoent}
    end
  end

  describe "fetch_last_update/0" do
    test "returns the checksum for the data", %{data: data} do
      assert FileSystem.put(data) == :ok
      assert {:ok, timestamp} = FileSystem.fetch_last_update()
      assert_in_delta(timestamp, now(), 3)
    end

    test "returns error if the data is unavalable" do
      File.rm!(@path)
      assert FileSystem.fetch_last_update() == {:error, :enoent}
    end
  end
end
