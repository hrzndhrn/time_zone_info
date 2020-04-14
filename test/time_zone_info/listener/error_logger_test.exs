defmodule TimeZoneInfo.Listener.ErrorLoggerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias TimeZoneInfo.Listener.ErrorLogger

  test "does not log on any event" do
    assert :ok = ErrorLogger.on_update(:foo)
  end

  test "logs an error" do
    log =
      capture_log(fn ->
        assert :ok = ErrorLogger.on_update({:error, :foo})
      end)

    assert log =~ "[error] TimeZoneInfo: Update failed! {:error, :foo}"
  end

  test "logs an error for invalid config" do
    log =
      capture_log(fn ->
        assert :ok = ErrorLogger.on_update({:error, {:invalid_config, [foo: :bar]}})
      end)

    assert log =~ "[error] TimeZoneInfo: Invalid config! path: [foo: :bar]"
  end

  test "logs an error for invalid update option" do
    log =
      capture_log(fn ->
        assert :ok = ErrorLogger.on_update({:error, {:invalid_config, [update: :bar]}})
      end)

    assert log =~ "[error] TimeZoneInfo: Invalid config! Found :bar for key"
    assert log =~ ":update, valid values are :disabled and :daily."
  end
end
