defmodule TimeZoneInfo.IanaDateTimeTest do
  use ExUnit.Case, async: true

  alias TimeZoneInfo.IanaDateTime

  describe "to_gregorian_seconds/4" do
    test "returns seconds for datetimes with [day: y, op: :ge, day_of_week: y]" do
      assert IanaDateTime.to_gregorian_seconds(
               1932,
               10,
               [day: 1, op: :ge, day_of_week: 7],
               {0, 0, 0}
             ) == to_gregorian_seconds(~N[1932-10-02 00:00:00])
    end

    test "returns seconds for datetimes with [day: 31, op: :ge, day_of_week: y]" do
      assert IanaDateTime.to_gregorian_seconds(
               1973,
               10,
               [day: 31, op: :ge, day_of_week: 7],
               {2, 0, 0}
             ) == to_gregorian_seconds(~N[1973-11-04 02:00:00])
    end
  end

  describe "to_gregorian_seconds/1" do
    test "with year" do
      assert IanaDateTime.to_gregorian_seconds({1999}) ==
               to_gregorian_seconds(~N[1999-01-01 00:00:00])
    end

    test "with year, month, day, hour, minute and second" do
      assert IanaDateTime.to_gregorian_seconds({1999, 2, 3, 10, 11, 12}) ==
               to_gregorian_seconds(~N[1999-02-03 10:11:12])
    end

    test "with day as last day of week" do
      # The last Monday in February 2019.
      day = [last_day_of_week: 1]

      assert IanaDateTime.to_gregorian_seconds({2019, 2, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-25 10:00:00])
    end

    test "with day as day of week with op ge" do
      # The first Sunday in February 2019.
      day = [day: 1, op: :ge, day_of_week: 7]

      assert IanaDateTime.to_gregorian_seconds({2019, 2, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-03 10:00:00])
    end

    test "with day as day of week with op ge and equal day" do
      # The first Sunday in February 2019.
      day = [day: 3, op: :ge, day_of_week: 7]

      assert IanaDateTime.to_gregorian_seconds({2019, 2, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-03 10:00:00])
    end

    test "with day as day of week with op ge and result in next month" do
      # The first Sunday in February 2019.
      day = [day: 31, op: :ge, day_of_week: 7]

      assert IanaDateTime.to_gregorian_seconds({2019, 1, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-03 10:00:00])
    end

    test "with day as day of week with op le" do
      # Saturday before 15 February 2019.
      day = [day: 15, op: :le, day_of_week: 6]

      assert IanaDateTime.to_gregorian_seconds({2019, 2, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-09 10:00:00])
    end

    test "with day as day of week with op le and equal day" do
      # Saturday before 15 February 2019.
      day = [day: 9, op: :le, day_of_week: 6]

      assert IanaDateTime.to_gregorian_seconds({2019, 2, day, 10}) ==
               to_gregorian_seconds(~N[2019-02-09 10:00:00])
    end
  end

  defp to_gregorian_seconds(naive_datetime) do
    naive_datetime |> NaiveDateTime.to_erl() |> :calendar.datetime_to_gregorian_seconds()
  end
end
