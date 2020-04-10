defmodule TimeZoneInfo.NaiveDateTimeUtil do
  @moduledoc """
  Some functions to handle datetimes in `TimeZoneInfo`.
  """

  alias Calendar.ISO
  alias TimeZoneInfo.IanaParser

  @seconds_per_minute 60
  @seconds_per_hour 60 * @seconds_per_minute
  @seconds_per_day 24 * @seconds_per_hour

  @microsecond {0, 0}

  @utc ~w(utc gmt zulu)a

  @typedoc "The number of gregorian seconds starting with year 0"
  @type gregorian_seconds :: non_neg_integer()

  @doc """
  Builds a new ISO naive datetime.

  This function differs in the types and arity from `NaiveDateTime.new/6`,
  because it handles also day formats from the IANA DB.
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

  defdelegate utc_now, to: NaiveDateTime
end
