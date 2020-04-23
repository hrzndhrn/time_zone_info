defmodule Clock do
  @moduledoc false

  use Agent

  require Logger

  alias IO.ANSI
  alias TimeZoneInfo.TimeZoneDatabase

  def start_link(_) do
    Agent.start_link(fn -> "Etc/UTC" end, name: __MODULE__)
  end

  def display do
    now = FakeUtcDateTime.now() |> DateTime.truncate(:second)
    datetime = DateTime.shift_zone!(now, get_time_zone())
    utc_offset = datetime.utc_offset

    period =
      now
      |> DateTime.to_naive()
      |> NaiveDateTime.add(utc_offset)
      |> TimeZoneDatabase.time_zone_periods_from_wall_datetime(get_time_zone())

    Logger.debug("utc: #{DateTime.to_string(now)}")
    Logger.debug("period: #{inspect(period, pretty: true)}")

    [
      ANSI.color_background(3),
      ANSI.black(),
      " Clock: ",
      DateTime.to_string(datetime),
      " ",
      ANSI.default_background(),
      ANSI.default_color()
    ]
    |> IO.iodata_to_binary()
    |> IO.puts()
  end

  def put_time_zone(time_zone) do
    case TimeZoneInfo.time_zones() |> Enum.member?(time_zone) do
      true ->
        Agent.update(__MODULE__, fn _ -> time_zone end)

      false ->
        {:error, :time_zone_not_found}
    end
  end

  def get_time_zone, do: Agent.get(__MODULE__, & &1)
end
