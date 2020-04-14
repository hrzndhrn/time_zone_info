defmodule TimeZoneInfo.Listener.ErrorLogger do
  @moduledoc """
  A listener to log `TimeZoneInfo` errors.
  """

  @behaviour TimeZoneInfo.Listener

  require Logger

  @impl true
  @doc """
  Listen on errors.
  """
  def on_update({:error, {:invalid_config, [update: value]}}) do
    """
    TimeZoneInfo: Invalid config!
    Found #{inspect(value)} for key :update, valid values are :disabled and
    :daily.
    """
    |> to_one_line()
    |> Logger.error()
  end

  def on_update({:error, {:invalid_config, path}}) do
    """
    TimeZoneInfo: Invalid config! path: #{inspect(path)}\
    """
    |> Logger.error()
  end

  def on_update({:error, _} = error) do
    Logger.error("TimeZoneInfo: Update failed! #{inspect(error)}")
  end

  def on_update(_), do: :ok

  defp to_one_line(string), do: String.replace(string, "\n", " ")
end
