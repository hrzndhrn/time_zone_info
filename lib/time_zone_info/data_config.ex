defmodule TimeZoneInfo.DataConfig do
  @moduledoc false

  # This module applies the configuration to the transition tables.

  alias TimeZoneInfo.Transformer

  @type config :: [time_zones: :all | [String.t()]]

  @separator "/"

  @doc """
  Returns the data updated by the configuration.
  """
  @spec update(TimeZoneInfo.data(), config()) ::
          {:ok, TimeZoneInfo.data()} | {:error, {:time_zones_not_found, [String.t()]}}
  def update(data, config), do: update(:time_zones, data, config[:time_zones])

  defp update(:time_zones, data, :all), do: {:ok, data}

  defp update(:time_zones, data, time_zones) when is_list(time_zones) do
    data
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

  defp filter(data, select) do
    time_zones = data |> Map.fetch!(:time_zones) |> Map.keys() |> split()
    select = split(select)

    {[], []}
    |> filter_time_zones(time_zones, select)
    |> filter_links(data.links)
    |> join()
  end

  defp filter_time_zones(acc, _time_zones, []), do: acc

  defp filter_time_zones({found, missing}, all, [time_zone | select]) do
    case time_zone_members(all, time_zone) do
      [] -> filter_time_zones({found, [time_zone | missing]}, all, select)
      time_zones -> filter_time_zones({time_zones ++ found, missing}, all, select)
    end
  end

  defp filter_links({found, missing}, links) do
    links =
      Enum.map(links, fn {from, to} ->
        {String.split(from, @separator), String.split(to, @separator)}
      end)

    filter_links({found, []}, links, missing)
  end

  defp filter_links(acc, _links, []), do: acc

  defp filter_links({found, missing}, links, [time_zone | select]) do
    case link_members(links, time_zone) do
      [] -> filter_links({found, [time_zone | missing]}, links, select)
      time_zones -> filter_links({time_zones ++ found, missing}, links, select)
    end
  end

  defp link_members(links, member) do
    Enum.reduce(links, [], fn {from, to}, acc ->
      case List.starts_with?(from, member) do
        true -> [to | acc]
        false -> acc
      end
    end)
  end

  defp time_zone_members(time_zones, member) do
    Enum.reduce(time_zones, [], fn time_zone, acc ->
      case List.starts_with?(time_zone, member) do
        true -> [time_zone | acc]
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
