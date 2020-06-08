defmodule FakeUtcDateTime do
  @moduledoc false

  use Agent

  @behaviour TimeZoneInfo.UtcDateTime

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @impl true
  def now, do: now(:datetime)

  @impl true
  def now(:datetime) do
    offset = case Process.whereis(__MODULE__) do
      nil -> 0
      _ ->
        get_offset()
    end

    DateTime.utc_now() |> DateTime.add(offset)
  end

  def put(%DateTime{} = datetime) do
    now = DateTime.utc_now |> DateTime.to_unix()
    put_offset(DateTime.to_unix(datetime) - now)
  end

  defp put_offset(offset), do: Agent.update(__MODULE__, fn _ -> offset end)

  defp get_offset, do: Agent.get(__MODULE__, fn offset -> offset end)
end
