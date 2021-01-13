defmodule TimeZoneInfo.UtcDateTimeTest do
  use ExUnit.Case, async: true

  import TimeZoneInfo.TestUtils, only: [put_env: 1, delete_env: 0]

  alias TimeZoneInfo.UtcDateTime

  defmodule UtcFixDateTime do
    @behaviour TimeZoneInfo.UtcDateTime

    @impl true
    def now, do: now(:datetime)

    @impl true
    def now(:datetime), do: fix()
    def now(:unix), do: DateTime.to_unix(fix())

    def fix, do: DateTime.utc_now() |> DateTime.add(-86400)
  end

  describe "now/1" do
    test "returns now as datetime" do
      now = DateTime.utc_now()

      assert_in_delta(
        DateTime.to_unix(now),
        UtcDateTime.now() |> DateTime.to_unix(),
        1
      )
    end

    test "returns now as unix" do
      now = DateTime.utc_now()
      assert_in_delta(DateTime.to_unix(now), UtcDateTime.now(:unix), 1)
    end
  end

  describe "now/1 with UtcFixDateTime" do
    setup do
      put_env(utc_datetime: UtcFixDateTime)
      on_exit(&delete_env/0)
    end

    test "retruns fixed datetime" do
      assert_in_delta(DateTime.diff(UtcFixDateTime.fix(), UtcDateTime.now()), 0, 1)
    end

    test "returns fixed datetime as unix" do
      assert_in_delta(UtcFixDateTime.fix() |> DateTime.to_unix(), UtcDateTime.now(:unix), 1)
    end
  end
end
