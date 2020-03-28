defmodule TimeZoneInfo.DataPersistenceTest do
  use ExUnit.Case

  import Mox
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{DataPersistence, DataPersistenceMock}

  setup do
    put_env(data_persistence: DataPersistenceMock)

    on_exit(&delete_env/0)
  end

  setup :verify_on_exit!

  test "put/1" do
    expect(DataPersistenceMock, :put, fn data -> data == "data" end)
    assert DataPersistence.put("data")
  end

  test "fetch/0" do
    expect(DataPersistenceMock, :fetch, fn -> true end)
    assert DataPersistence.fetch()
  end

  test "fetch_last_update/0" do
    expect(DataPersistenceMock, :fetch_last_update, fn -> true end)
    assert DataPersistence.fetch_last_update()
  end

  test "put_last_update/1" do
    expect(DataPersistenceMock, :put_last_update, fn data -> data == 1 end)
    assert DataPersistence.put_last_update(1)
  end

  test "checksum/0" do
    expect(DataPersistenceMock, :checksum, fn -> true end)
    assert DataPersistence.checksum()
  end

  test "throws error if config is unset" do
    delete_env()

    assert_raise ArgumentError, fn ->
      DataPersistence.checksum()
    end
  end
end
