defmodule Debug do
  @moduledoc false

  require Logger

  alias TimeZoneInfo.DataStore
  alias TimeZoneInfo.GregorianSeconds

  def transitions(time_zone) do
    with {:ok, transitions} <- DataStore.get_transitions(time_zone) do
      Enum.map(transitions, fn
        {seconds, value} -> {GregorianSeconds.to_naive(seconds), value}
      end)
    end
  end
end
