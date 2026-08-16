defmodule TimeZoneInfo.DataStore.PersistentTerm do
  @moduledoc false

  # This module implements the `TimeZoneInfo.DataStore` and stores the data with
  # [:persistent_term](https://erlang.org/doc/man/persistent_term.html).

  @behaviour TimeZoneInfo.DataStore

  @time_zones_key {:time_zone_info, :time_zones}
  @rules_key {:time_zone_info, :rules}
  @links_key {:time_zone_info, :links}
  @version_key {:time_zone_info, :version}

  @impl true
  def put(data) do
    data =
      Map.merge(%{time_zones: %{}, rules: %{}, links: %{}, version: "unknown"}, data)

    :persistent_term.put(@time_zones_key, data.time_zones)
    :persistent_term.put(@rules_key, data.rules)
    :persistent_term.put(@links_key, data.links)
    :persistent_term.put(@version_key, data.version)
  end

  @impl true
  def fetch_transitions(time_zone, is_link \\ false) do
    with :error <- fetch(@time_zones_key, time_zone) do
      fetch_transitions_by_link(time_zone, is_link)
    end
  end

  @impl true
  def fetch_rules(rules) do
    with :error <- fetch(@rules_key, rules) do
      {:error, :rules_not_found}
    end
  end

  @impl true
  def get_time_zones(links: :ignore) do
    fetch(@time_zones_key) |> Map.keys() |> Enum.sort()
  end

  def get_time_zones(links: :only) do
    fetch(@links_key) |> Map.keys() |> Enum.sort()
  end

  def get_time_zones(links: :include) do
    time_zones = fetch(@time_zones_key)
    links = fetch(@links_key)
    Enum.sort(Map.keys(time_zones) ++ Map.keys(links))
  end

  @impl true
  def empty?, do: :persistent_term.get(@time_zones_key, nil) == nil

  @impl true
  def version, do: get(@version_key)

  @impl true
  def delete! do
    :persistent_term.erase(@time_zones_key)
    :persistent_term.erase(@rules_key)
    :persistent_term.erase(@links_key)
    :persistent_term.erase(@version_key)
    :ok
  end

  @impl true
  def info do
    memory =
      Enum.sum_by(
        [@time_zones_key, @rules_key, @links_key],
        fn key ->
          case :persistent_term.get(key, nil) do
            nil -> 0
            data -> data |> :erlang.term_to_binary() |> byte_size()
          end
        end
      )

    %{
      version: version(),
      memory: memory,
      time_zones: length(get_time_zones(links: :ignore)),
      links: length(get_time_zones(links: :only))
    }
  end

  defp get(key) do
    :persistent_term.get(key)
  rescue
    _ -> %{}
  end

  defp fetch(key) do
    :persistent_term.get(key)
  rescue
    _ -> %{}
  end

  defp fetch(key, sub_key) do
    key
    |> fetch()
    |> Map.fetch(sub_key)
  end

  defp fetch_transitions_by_link(_link, true), do: {:error, :transitions_not_found}

  defp fetch_transitions_by_link(link, false) do
    case fetch(@links_key, link) do
      {:ok, time_zone} -> fetch_transitions(time_zone, true)
      :error -> {:error, :transitions_not_found}
    end
  end
end
