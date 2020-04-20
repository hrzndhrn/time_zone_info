defmodule FakeUtcDateTimeTest do
  use ExUnit.Case, async: true

  alias FakeUtcDateTime
  alias TimeZoneInfo.UtcDateTime

  test "returns faked datetime" do
    FakeUtcDateTime.put(DateTime.utc_now() |> DateTime.add(100))

    assert_in_delta(
      DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(100),
      UtcDateTime.now() |> DateTime.to_unix(),
      101
    )
  end

  test "returns faked datetime as Unix time" do
    FakeUtcDateTime.put(DateTime.utc_now() |> DateTime.add(100))

    assert_in_delta(
      DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(100),
      UtcDateTime.now(:unix),
      101
    )
  end
end


