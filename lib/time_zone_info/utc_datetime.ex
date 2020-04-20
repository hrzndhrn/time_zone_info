defmodule TimeZoneInfo.UtcDateTime do
  @moduledoc false

  # A behaviour to wrap DateTime.utc_now/0

  @callback now() :: DateTime.t()

  def now(type \\ :datetime)

  def now(:datetime) do
    case Application.get_env(:time_zone_info, :utc_datetime) do
      nil -> DateTime.utc_now()
      mod -> mod.now()
    end
  end

  def now(:unix), do: now() |> DateTime.to_unix()
end
