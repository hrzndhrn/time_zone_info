defmodule TimeZoneInfo.IsoDays do
  @moduledoc false
  # A module to handle ISO days.

  alias Calendar.ISO
  alias TimeZoneInfo.GregorianSeconds

  @seconds_per_day 24 * 60 * 60
  @microseconds_per_second 1_000_000
  @parts_per_day @seconds_per_day * @microseconds_per_second

  @doc """
  Converts an ISO day to gregorian seconds.
  """
  @spec to_gregorian_seconds(Calendar.iso_days()) :: GregorianSeconds.t()
  def to_gregorian_seconds({days, {parts_in_day, @parts_per_day}}) do
    div(days * @parts_per_day + parts_in_day, @microseconds_per_second)
  end

  @doc """
  Converts an ISO day to year.
  """
  @spec to_year(Calendar.iso_days()) :: Calendar.year()
  def to_year(iso_days) do
    {year, _, _, _, _, _, _} = ISO.naive_datetime_from_iso_days(iso_days)
    year
  end
end
