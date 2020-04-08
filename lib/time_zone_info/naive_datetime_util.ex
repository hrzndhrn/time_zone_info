defmodule TimeZoneInfo.NaiveDateTimeUtil do
  @moduledoc """
  Some functions to handle datetimes in `TimeZoneInfo`.
  """

  alias Calendar.ISO
  alias TimeZoneInfo.IanaParser

  @compile {:inline, compare: 2, sorter: 1}

  @seconds_per_minute 60
  @seconds_per_hour 60 * @seconds_per_minute
  @seconds_per_day 24 * @seconds_per_hour

  @microsecond {0, 0}

  @utc ~w(utc gmt zulu)a

  @typedoc "The number of gregorian seconds starting with year 0"
  @type gregorian_seconds :: non_neg_integer()

  @doc """
  Builds a new ISO naive datetime.

  This function differs in the types and arity from `NaiveDateTime.new/6`.
  """
  @spec new(
          Calendar.year(),
          Calendar.month(),
          IanaParser.day(),
          Calendar.hour(),
          Calendar.minute(),
          Calendar.second()
        ) :: NaiveDateTime.t()
  def new(year, month \\ 1, day \\ 1, hour \\ 0, minute \\ 0, second \\ 0)

  def new(year, month, day, hour, minute, second) when is_integer(day) do
    with {:ok, naive_datetime} <- NaiveDateTime.new(year, month, day, 0, 0, 0) do
      seconds = hour * @seconds_per_hour + minute * @seconds_per_minute + second
      NaiveDateTime.add(naive_datetime, seconds, :second)
    end
  end

  def new(year, month, day, hour, minute, second) do
    year
    |> new(month, 1, hour, minute, second)
    |> NaiveDateTime.add(to_day(year, month, day) * @seconds_per_day, :second)
  end

  defp to_day(year, month, last_day_of_week: last_day_of_week),
    do: to_last_day_of_week(year, month, last_day_of_week) - 1

  defp to_day(year, month, day: day, op: op, day_of_week: day_of_week),
    do: to_day_of_week(year, month, day, day_of_week, op) - 1

  defp to_last_day_of_week(year, month, day_of_week) do
    days_in_month = ISO.days_in_month(year, month)
    last = ISO.day_of_week(year, month + 1, 1) - 1

    days_in_month - rem(7 - (day_of_week - last), 7)
  end

  defp to_day_of_week(year, month, day, day_of_week, op) do
    current = ISO.day_of_week(year, month, day)

    case op do
      :ge -> day + rem(7 + (day_of_week - current), 7)
      :le -> day - rem(7 + (current - day_of_week), 7)
    end
  end

  @doc """
  Builds a new ISO naive datetime from parsed IANA data.
  """
  @spec from_iana(tuple()) :: NaiveDateTime.t()
  def from_iana(tuple) do
    apply(__MODULE__, :new, Tuple.to_list(tuple))
  end

  @spec from_iana(Calendar.year(), tuple()) :: NaiveDateTime.t()
  def from_iana(year, tuple) do
    apply(__MODULE__, :new, [year | Tuple.to_list(tuple)])
  end

  @spec from_iana(
          Calendar.year(),
          Calendar.month(),
          IanaParser.day(),
          IanaParser.time()
        ) :: NaiveDateTime.t()
  def from_iana(year, month, day, {hour, minute, second}) do
    new(year, month, day, hour, minute, second)
  end

  @doc """
  Returns the Calendar.iso_days/0 format of the specified date.
  """
  @spec to_iso_days(NaiveDateTime.t()) :: Calendar.iso_days()
  def to_iso_days(%NaiveDateTime{year: yr, month: mo, day: dy, hour: hr, minute: m, second: s}),
    do: ISO.naive_datetime_to_iso_days(yr, mo, dy, hr, m, s, @microsecond)

  @doc """
  Builds a new ISO naive datetime from iso days.
  """
  @spec from_iso_days(Calendar.iso_days()) :: NaiveDateTime.t()
  def from_iso_days(iso_days) do
    naive_datetime = iso_days |> ISO.naive_datetime_from_iso_days()
    {:ok, naive_datetime} = NaiveDateTime |> apply(:new, Tuple.to_list(naive_datetime))
    naive_datetime
  end

  @doc """
  Computes the number of gregorian seconds starting with year 0 and ending at
  the specified date and time.
  """
  @spec to_gregorian_seconds(NaiveDateTime.t()) :: gregorian_seconds()
  def to_gregorian_seconds(%NaiveDateTime{year: year}) when year < 0, do: 0

  def to_gregorian_seconds(datetime) do
    datetime
    |> NaiveDateTime.to_erl()
    |> :calendar.datetime_to_gregorian_seconds()
  end

  @doc """
  Computes the date and time from the specified number of gregorian seconds.
  """
  @spec from_gregorian_seconds(gregorian_seconds()) :: NaiveDateTime.t()
  def from_gregorian_seconds(seconds) when seconds >= 0 do
    seconds
    |> :calendar.gregorian_seconds_to_datetime()
    |> NaiveDateTime.from_erl!()
  end

  @doc """
  Returns a naive datetime at the end of the year for the given `year` or
  `datetime`.
  """
  @spec end_of_year(Calendar.year()) :: NaiveDateTime.t()
  def end_of_year(year) when is_integer(year) do
    with {:ok, datetime} <- NaiveDateTime.new(year, 12, 31, 23, 59, 59),
         do: datetime
  end

  @spec end_of_year(NaiveDateTime.t()) :: NaiveDateTime.t()
  def end_of_year(datetime), do: end_of_year(datetime.year)

  @doc """
  Returns true if `naive_datetime1` is before `naive_datetime2`.
  """
  @spec before?(NaiveDateTime.t(), NaiveDateTime.t()) :: boolean
  def before?(%NaiveDateTime{} = naive_datetime1, %NaiveDateTime{} = naive_datetime2),
    do: compare(naive_datetime1, naive_datetime2) < 0

  @doc """
  Returns `true` if `naive_datetime1` is before or equal to `naive_datetime2`.
  """
  @spec before_or_equal?(NaiveDateTime.t(), NaiveDateTime.t()) :: boolean()
  def before_or_equal?(%NaiveDateTime{} = naive_datetime1, %NaiveDateTime{} = naive_datetime2),
    do: compare(naive_datetime1, naive_datetime2) <= 0

  @doc """
  Returns `true` if `naive_datetime1` is after or equal to `naive_datetime2`.
  """
  @spec after?(NaiveDateTime.t(), NaiveDateTime.t()) :: boolean()
  def after?(%NaiveDateTime{} = naive_datetime1, %NaiveDateTime{} = naive_datetime2),
    do: compare(naive_datetime1, naive_datetime2) > 0

  @doc """
  Returns `true` if `naive_datetime1` is after or equal to `naive_datetime2`.
  """
  @spec after_or_equal?(NaiveDateTime.t(), NaiveDateTime.t()) :: boolean()
  def after_or_equal?(%NaiveDateTime{} = naive_datetime1, %NaiveDateTime{} = naive_datetime2),
    do: compare(naive_datetime1, naive_datetime2) >= 0

  @doc """
  Returns `true` if the given time spans are overlapping.
  """
  @spec overlap?(
          {NaiveDateTime.t(), NaiveDateTime.t()},
          {NaiveDateTime.t(), NaiveDateTime.t()}
        ) :: boolean()
  def overlap?({naive_datetime_a, naive_datetime_b}, {naive_datetime_x, naive_datetime_y}) do
    cond do
      before?(naive_datetime_b, naive_datetime_x) -> false
      after?(naive_datetime_a, naive_datetime_y) -> false
      true -> true
    end
  end

  defp compare(%NaiveDateTime{} = datetime_a, %NaiveDateTime{} = datetime_b) do
    cond do
      datetime_a.year != datetime_b.year -> datetime_a.year - datetime_b.year
      datetime_a.month != datetime_b.month -> datetime_a.month - datetime_b.month
      datetime_a.day != datetime_b.day -> datetime_a.day - datetime_b.day
      datetime_a.hour != datetime_b.hour -> datetime_a.hour - datetime_b.hour
      datetime_a.minute != datetime_b.minute -> datetime_a.minute - datetime_b.minute
      datetime_a.second != datetime_b.second -> datetime_a.second - datetime_b.second
      true -> 0
    end
  end

  @doc """
  Converts a datetime to UTC.
  """
  @spec to_utc(
          NaiveDateTime.t(),
          TimeZoneInfo.time_standard(),
          Calendar.utc_offset(),
          Calendar.std_offset()
        ) :: NaiveDateTime.t()
  def to_utc(datetime, time_standard, utc_offset, std_offset \\ 0)

  def to_utc(datetime, time_standard, _, _) when time_standard in @utc, do: datetime

  def to_utc(datetime, time_standard, utc_offset, std_offset) do
    case time_standard do
      :wall -> NaiveDateTime.add(datetime, (utc_offset + std_offset) * -1)
      :standard -> NaiveDateTime.add(datetime, utc_offset * -1)
    end
  end

  @doc """
  Sorts the given list of tuples by the datetime specified in the first element.
  """
  @spec sort([{NaiveDateTime.t(), any()}], :desc | :asc) :: [{NaiveDateTime.t(), any()}]
  def sort(tuples, dir \\ :asc), do: Enum.sort(tuples, sorter(dir))

  defp sorter(:asc), do: fn a, b -> before?(elem(a, 0), elem(b, 0)) end

  defp sorter(:desc), do: fn a, b -> before?(elem(b, 0), elem(a, 0)) end

  defdelegate add(datetime, seconds), to: NaiveDateTime

  defdelegate utc_now, to: NaiveDateTime
end
