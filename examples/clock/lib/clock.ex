defmodule Clock do
  @moduledoc false

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> "Etc/UTC" end, name: __MODULE__)
  end

  def display do
    FakeUtcDateTime.now()
    |> DateTime.shift_zone!(get_time_zone())
    |> DateTime.truncate(:second)
    |> DateTime.to_string()
  end

  def put_time_zone(time_zone) do
    case TimeZoneInfo.time_zones() |> Enum.member?(time_zone) do
      true ->
        Agent.update(__MODULE__, fn _ -> time_zone end)
        {:ok, display()}

      false ->
        {:error, :time_zone_not_found}
    end
  end

  def get_time_zone, do: Agent.get(__MODULE__, & &1)
end
