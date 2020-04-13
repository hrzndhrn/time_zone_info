defmodule TimeZoneInfo.DataConfig do
  @moduledoc """
  This module applies the configuration to the transition tables.
  """

  alias TimeZoneInfo.Transformer

  @type config :: [time_zones: :all | [String.t()]]

  @separator "/"

  @doc """
  Returns the data updated by the configuration.
  """
  @spec update(TimeZoneInfo.data(), config()) :: TimeZoneInfo.data()
  def update(data, config) do
    with {:ok, data} <- update(:time_zones, data, config[:time_zones]) do
      {:ok, data}
    end
  end

  defp update(:time_zones, data, :all), do: {:ok, data}

  defp update(:time_zones, data, time_zones) when not is_nil(time_zones) do
    data
    |> Map.fetch!(:time_zones)
    |> Map.keys()
    |> filter(time_zones)
    |> case do
      {time_zones, []} ->
        select(data, time_zones)

      {_, missing} ->
        {:error, {:time_zones_not_found, missing}}
    end
  end

  defp select(data, time_zones) do
    time_zones =
      data.time_zones
      |> Enum.filter(fn {name, _} -> Enum.member?(time_zones, name) end)
      |> Enum.into(%{})

    rules = rules(data, time_zones)
    links = links(data, time_zones)

    {:ok, %{time_zones: time_zones, rules: rules, links: links, version: data.version}}
  end

  defp rules(data, time_zones) do
    used_rules = Transformer.used_rules(time_zones)

    data.rules
    |> Enum.filter(fn {name, _} -> Enum.member?(used_rules, name) end)
    |> Enum.into(%{})
  end

  defp links(data, time_zones) do
    names = Map.keys(time_zones)

    data
    |> Map.get(:links, %{})
    |> Enum.filter(fn {_, name} -> Enum.member?(names, name) end)
    |> Enum.into(%{})
  end

  defp filter(all, select) do
    all = split(all)
    select = split(select)

    all
    |> filter(select, {[], []})
    |> join()
  end

  defp filter(all, [], acc), do: acc

  defp filter(all, [time_zone | select], {found, missing}) do
    case members(all, time_zone) do
      [] -> filter(all, select, {found, [time_zone | missing]})
      time_zones -> filter(all, select, {time_zones ++ found, missing})
    end
  end

  defp members(time_zones, member) do
    Enum.reduce(time_zones, [], fn time_zone, acc ->
      case List.starts_with?(time_zone, member) do
        true -> [time_zone|acc]
        false -> acc
      end
    end)
  end

  defp split(list), do: Enum.map(list, &String.split(&1, @separator))

  defp join({time_zones_found, time_zones_missing}),
    do: {join(time_zones_found), join(time_zones_missing)}

  defp join(time_zones),
    do: Enum.map(time_zones, &Enum.join(&1, @separator))
end
