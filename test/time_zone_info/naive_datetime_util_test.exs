defmodule TimeZoneInfo.NaiveDateTimeUtilTest do
  use ExUnit.Case, async: true

  alias TimeZoneInfo.NaiveDateTimeUtil

  describe "new/6" do
    test "with year" do
      assert NaiveDateTimeUtil.new(1999) == ~N[1999-01-01 00:00:00]
    end

    test "with year, month, day, hour, minute and second" do
      assert NaiveDateTimeUtil.new(1999, 2, 3, 10, 11, 12) == ~N[1999-02-03 10:11:12]
    end

    test "with day as last day of week" do
      # The last Monday in February 2019.
      day = [last_day_of_week: 1]
      assert NaiveDateTimeUtil.new(2019, 2, day, 10) == ~N[2019-02-25 10:00:00]
    end

    test "with day as day of week with op ge" do
      # The first Sunday in February 2019.
      day = [day: 1, op: :ge, day_of_week: 7]
      assert NaiveDateTimeUtil.new(2019, 2, day, 10) == ~N[2019-02-03 10:00:00]
    end

    test "with day as day of week with op ge and equal day" do
      # The first Sunday in February 2019.
      day = [day: 3, op: :ge, day_of_week: 7]
      assert NaiveDateTimeUtil.new(2019, 2, day, 10) == ~N[2019-02-03 10:00:00]
    end

    test "with day as day of week with op ge and result in next month" do
      # The first Sunday in February 2019.
      day = [day: 31, op: :ge, day_of_week: 7]
      assert NaiveDateTimeUtil.new(2019, 1, day, 10) == ~N[2019-02-03 10:00:00]
    end

    test "with day as day of week with op le" do
      # Saturday before 15 February 2019.
      day = [day: 15, op: :le, day_of_week: 6]
      assert NaiveDateTimeUtil.new(2019, 2, day, 10) == ~N[2019-02-09 10:00:00]
    end

    test "with day as day of week with op le and equal day" do
      # Saturday before 15 February 2019.
      day = [day: 9, op: :le, day_of_week: 6]
      assert NaiveDateTimeUtil.new(2019, 2, day, 10) == ~N[2019-02-09 10:00:00]
    end
  end

  describe "before?/2" do
    test "with a before b" do
      b = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.before?(~N[2019-02-09 10:10:09], b)
      assert NaiveDateTimeUtil.before?(~N[2019-02-09 10:09:10], b)
      assert NaiveDateTimeUtil.before?(~N[2019-02-08 10:10:10], b)
      assert NaiveDateTimeUtil.before?(~N[2018-02-09 10:10:10], b)
    end

    test "with b before a" do
      b = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.before?(~N[2019-02-09 10:10:11], b)
      refute NaiveDateTimeUtil.before?(~N[2019-02-09 10:11:10], b)
      refute NaiveDateTimeUtil.before?(~N[2019-02-10 10:10:10], b)
      refute NaiveDateTimeUtil.before?(~N[2022-02-09 10:10:10], b)
    end

    test "with a equal b" do
      a = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.before?(a, a)
    end
  end

  describe "before_or_equal/2" do
    test "with a before b" do
      b = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.before_or_equal?(~N[2019-02-09 10:10:09], b)
      assert NaiveDateTimeUtil.before_or_equal?(~N[2019-02-09 10:09:10], b)
      assert NaiveDateTimeUtil.before_or_equal?(~N[2019-02-08 10:10:10], b)
      assert NaiveDateTimeUtil.before_or_equal?(~N[2018-02-09 10:10:10], b)
    end

    test "with b before a" do
      b = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.before_or_equal?(~N[2019-02-09 10:10:11], b)
      refute NaiveDateTimeUtil.before_or_equal?(~N[2019-02-09 10:11:10], b)
      refute NaiveDateTimeUtil.before_or_equal?(~N[2019-02-10 10:10:10], b)
      refute NaiveDateTimeUtil.before_or_equal?(~N[2022-02-09 10:10:10], b)
    end

    test "with a equal b" do
      a = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.before_or_equal?(a, a)
    end
  end

  describe "after?/2" do
    test "with a after b" do
      b = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.after?(~N[2019-02-09 10:10:09], b)
      refute NaiveDateTimeUtil.after?(~N[2019-02-09 10:09:10], b)
      refute NaiveDateTimeUtil.after?(~N[2019-02-08 10:10:10], b)
      refute NaiveDateTimeUtil.after?(~N[2018-02-09 10:10:10], b)
    end

    test "with b after a" do
      b = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.after?(~N[2019-02-09 10:10:11], b)
      assert NaiveDateTimeUtil.after?(~N[2019-02-09 10:11:10], b)
      assert NaiveDateTimeUtil.after?(~N[2019-02-10 10:10:10], b)
      assert NaiveDateTimeUtil.after?(~N[2022-02-09 10:10:10], b)
    end

    test "with a equal b" do
      a = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.after?(a, a)
    end
  end

  describe "after_or_equal/2" do
    test "with a after b" do
      b = ~N[2019-02-09 10:10:10]
      refute NaiveDateTimeUtil.after_or_equal?(~N[2019-02-09 10:10:09], b)
      refute NaiveDateTimeUtil.after_or_equal?(~N[2019-02-09 10:09:10], b)
      refute NaiveDateTimeUtil.after_or_equal?(~N[2019-02-08 10:10:10], b)
      refute NaiveDateTimeUtil.after_or_equal?(~N[2018-02-09 10:10:10], b)
    end

    test "with b after a" do
      b = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.after_or_equal?(~N[2019-02-09 10:10:11], b)
      assert NaiveDateTimeUtil.after_or_equal?(~N[2019-02-09 10:11:10], b)
      assert NaiveDateTimeUtil.after_or_equal?(~N[2019-02-10 10:10:10], b)
      assert NaiveDateTimeUtil.after_or_equal?(~N[2022-02-09 10:10:10], b)
    end

    test "with a equal b" do
      a = ~N[2019-02-09 10:10:10]
      assert NaiveDateTimeUtil.after_or_equal?(a, a)
    end
  end

  describe "overlap?/2" do
    test "first time span after second time span" do
      assert NaiveDateTimeUtil.overlap?(
               {~N[2000-01-01 10:10:10], ~N[2000-01-02 10:10:10]},
               {~N[2000-01-10 10:10:10], ~N[2000-01-20 10:10:10]}
             ) == false
    end

    test "first time span ends in second time span" do
      assert NaiveDateTimeUtil.overlap?(
               {~N[2000-01-01 10:10:10], ~N[2000-01-12 10:10:10]},
               {~N[2000-01-10 10:10:10], ~N[2000-01-20 10:10:10]}
             ) == true
    end
  end

  describe "sort/1" do
    test "asc" do
      assert NaiveDateTimeUtil.sort([
               {~N[2000-01-01 10:10:10], 1},
               {~N[2000-01-12 10:10:10], 3},
               {~N[2000-01-11 10:10:10], 2}
             ]) == [
               {~N[2000-01-01 10:10:10], 1},
               {~N[2000-01-11 10:10:10], 2},
               {~N[2000-01-12 10:10:10], 3}
             ]
    end
  end

  describe "sort/2" do
    test "asc" do
      assert NaiveDateTimeUtil.sort(
               [
                 {~N[2000-01-01 10:10:10], 1},
                 {~N[2000-01-12 10:10:10], 3},
                 {~N[2000-01-11 10:10:10], 2}
               ],
               :asc
             ) == [
               {~N[2000-01-01 10:10:10], 1},
               {~N[2000-01-11 10:10:10], 2},
               {~N[2000-01-12 10:10:10], 3}
             ]
    end

    test "desc" do
      assert NaiveDateTimeUtil.sort(
               [
                 {~N[2000-01-01 10:10:10], 1},
                 {~N[2000-01-12 10:10:10], 3},
                 {~N[2000-01-11 10:10:10], 2}
               ],
               :desc
             ) == [
               {~N[2000-01-12 10:10:10], 3},
               {~N[2000-01-11 10:10:10], 2},
               {~N[2000-01-01 10:10:10], 1}
             ]
    end
  end
end
