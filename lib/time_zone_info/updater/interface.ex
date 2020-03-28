defmodule TimeZoneInfo.Updater.Interface do
  @moduledoc false

  alias TimeZoneInfo.Updater

  @callback update :: :ok | {:next, Calendar.second()} | {:error, term()}
  @callback update(opt :: :run | :force) :: :ok | {:next, Calendar.second()} | {:error, term()}

  defp impl, do: Application.get_env(:time_zone_info, :updater, Updater)

  @spec update(opt :: :run | :force) :: :ok | {:next, Calendar.second()} | {:error, term()}
  def update(opt \\ :run) when opt in [:run, :force], do: impl().update(opt)
end
