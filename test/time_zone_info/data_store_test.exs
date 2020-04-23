defmodule TimeZoneInfo.DataStoreTest do
  use ExUnit.Case

  import Mox
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{DataStore, DataStoreMock}

  setup do
    put_env(data_store: DataStoreMock)

    on_exit(&delete_env/0)
  end

  setup :verify_on_exit!

  test "put/1" do
    expect(DataStoreMock, :put, fn data -> data == "data" end)
    assert DataStore.put("data")
  end

  test "get_transitions/1" do
    expect(DataStoreMock, :get_transitions, fn data -> data == "data" end)
    assert DataStore.get_transitions("data")
  end

  test "get_rules/1" do
    expect(DataStoreMock, :get_rules, fn data -> data == "data" end)
    assert DataStore.get_rules("data")
  end

  test "get_time_zones/1" do
    expect(DataStoreMock, :get_time_zones, fn _data -> [] end)
    assert DataStore.get_time_zones(links: :include) == ["Etc/UTC"]
  end

  test "version/0" do
    expect(DataStoreMock, :version, fn -> true end)
    assert DataStore.version()
  end

  test "empty?/0" do
    expect(DataStoreMock, :empty?, fn -> true end)
    assert DataStore.empty?()
  end

  test "delete!/0" do
    expect(DataStoreMock, :delete!, fn -> true end)
    assert DataStore.delete!()
  end

  test "throws error if config is unset" do
    delete_env()

    assert_raise ArgumentError, fn ->
      DataStore.empty?()
    end
  end
end
