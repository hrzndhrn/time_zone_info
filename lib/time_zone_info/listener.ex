defmodule TimeZoneInfo.Listener do
  @moduledoc """
  A `behaviour` for `TimeZoneInfo` listeners.
  """

  @doc """
  A callback to listen on the update process.

  Possible steps:
  - `:initial` initializing data.
  - `:check` checking whether an update is necessary.
  - `:download` downloads data.
  - `:update` updating data.
  """
  @callback on_update(step :: atom()) :: :ok | :undefined

  defp impl do
    case Application.get_env(:time_zone_info, :listener) do
      module when is_atom(module) and module != nil -> {:ok, module}
      _ -> :undefined
    end
  end

  @doc false
  @spec on_update(step :: atom()) :: :ok | :undefined
  def on_update(step) do
    with {:ok, module} <- impl() do
      module.on_update(step)
    end
  end
end
