defmodule TimeZoneInfo.WorkerTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import Mox
  import TimeZoneInfo.TestUtils

  alias TimeZoneInfo.{UpdaterMock, Worker}

  setup_all do
    Application.put_env(:time_zone_info, :updater, TimeZoneInfo.UpdaterMock)

    on_exit(fn ->
      Application.delete_env(:time_zone_info, :updater)
    end)
  end

  setup :set_mox_global
  setup :verify_on_exit!

  describe "start_link/1" do
    test "ends in state :ok" do
      expect(UpdaterMock, :update, 1, fn _ -> :ok end)

      assert {:ok, _pid} = Worker.start_link(name: :worker_test)

      assert Worker.state(:worker_test) == :ok
      assert Worker.next(:worker_test) == {:next, :never}
    end

    test "call update" do
      expect(UpdaterMock, :update, 1, fn _ -> :ok end)

      assert {:ok, _pid} = Worker.start_link(name: :worker_test)

      assert Worker.state(:worker_test) == :ok
      assert Worker.next(:worker_test) == {:next, :never}
    end

    test "ends in state {:error, ...}" do
      expect(UpdaterMock, :update, 1, fn _ -> {:error, :foo} end)

      log =
        capture_log(fn ->
          assert {:ok, _pid} = Worker.start_link(name: :worker_test)
        end)

      assert log =~ "[error] TimeZoneInfo update failed! {:error, :foo}"
      assert Worker.state(:worker_test) == {:error, :foo}
      assert Worker.next(:worker_test) == {:error, :foo}
    end

    test "logs an error for an invalid :update value" do
      expect(UpdaterMock, :update, 1, fn _ ->
        {:error, {:invalid_config, [update: 42]}}
      end)

      log =
        capture_log(fn ->
          assert {:ok, _pid} = Worker.start_link(name: :worker_test)
        end)

      assert log =~ "[error] TimeZoneInfo config invalid. Found 42 for key :update"
      assert log =~ "valid values are :disabled and :daily."
    end

    test "logs an error for an invalid config" do
      expect(UpdaterMock, :update, 1, fn _ ->
        {:error, {:invalid_config, [foo: 42]}}
      end)

      log =
        capture_log(fn ->
          assert {:ok, _pid} = Worker.start_link(name: :worker_test)
        end)

      assert log =~ "[error] TimeZoneInfo config invalid. path: [foo: 42]"
    end

    test "recalls update after {:next, seconds}" do
      now = now()
      test_pid = self()

      expect(UpdaterMock, :update, 2, fn _ ->
        send(test_pid, :next)
        {:next, now + 1}
      end)

      assert {:ok, _pid} = Worker.start_link(name: :worker_test)
      assert_receive :next

      assert {:next, _datetime_state} = Worker.state(:worker_test)
      assert {:next, datetime_next} = Worker.next(:worker_test)
      assert now < DateTime.to_unix(datetime_next)

      assert_receive :next, 2_000
    end
  end

  describe "update/0" do
    test "ends in state :ok" do
      expect(UpdaterMock, :update, 2, fn _ -> :ok end)

      assert {:ok, _pid} = Worker.start_link(name: :worker_test)
      assert Worker.update(:worker_test, :run) == :ok
      assert Worker.state(:worker_test) == :ok
      assert Worker.next(:worker_test) == {:next, :never}
    end
  end
end
