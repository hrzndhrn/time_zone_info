defmodule TimeZoneInfo.DataStore do
  @moduledoc """
  A module to store the time zone data in the persistent term.
  """

  @key :time_zone_info

  @spec put(data :: TimeZoneInfo.data()) :: :ok | :error
  def put(data) do
    :persistent_term.put({@key, :time_zones}, Map.get(data, :time_zones, %{}))
    :persistent_term.put({@key, :rules}, Map.get(data, :rules, %{}))
    :persistent_term.put({@key, :links}, Map.get(data, :links, %{}))
    :persistent_term.put({@key, :config}, Map.get(data, :config))
    :persistent_term.put({@key, :version}, Map.get(data, :version))
  end

  @spec fetch_transitions(time_zone :: Calendar.time_zone()) ::
          {:ok, transitions :: [TimeZoneInfo.transition()]} | {:error, :transitions_not_found}
  def fetch_transitions(time_zone, is_link \\ false) do
    with :error <- fetch(:time_zones, time_zone) do
      fetch_transitions_by_link(time_zone, is_link)
    end
  end

  @spec fetch_rules(rule_name :: TimeZoneInfo.rule_name()) ::
          {:ok, rules :: [TimeZoneInfo.rule()]} | {:error, :rules_not_found}
  def fetch_rules(rules) do
    with :error <- fetch(:rules, rules) do
      {:error, :rules_not_found}
    end
  end

  @spec get_time_zones(links: :include | :ignore | :only) :: [Calendar.time_zone()]
  def get_time_zones(links: :ignore) do
    case fetch(:time_zones) do
      {:ok, time_zones} -> time_zones |> Map.keys() |> Enum.sort()
      :error -> []
    end
  end

  def get_time_zones(links: :only) do
    case fetch(:links) do
      {:ok, links} -> links |> Map.keys() |> Enum.sort()
      :error -> []
    end
  end

  def get_time_zones(links: :include) do
    with {:ok, time_zones} <- fetch(:time_zones),
         {:ok, links} <- fetch(:links) do
      Enum.sort(Map.keys(time_zones) ++ Map.keys(links))
    else
      _error -> []
    end
  end

  @spec empty? :: boolean
  def empty?, do: :persistent_term.get({@key, :time_zones}, nil) == nil

  @spec version :: String.t() | nil
  def version, do: get(:version)

  @spec delete! :: :ok
  def delete! do
    :persistent_term.erase({@key, :time_zones})
    :persistent_term.erase({@key, :rules})
    :persistent_term.erase({@key, :links})
    :persistent_term.erase({@key, :config})
    :persistent_term.erase({@key, :version})
    :ok
  end

  @spec info :: term()
  def info do
    memory =
      [:time_zones, :rules, :links, :config, :version]
      |> Enum.map(fn sub_key ->
        case :persistent_term.get({@key, sub_key}, nil) do
          nil -> 0
          data -> data |> :erlang.term_to_binary() |> byte_size()
        end
      end)
      |> Enum.sum()

    %{
      version: version(),
      memory: memory,
      time_zones: length(get_time_zones(links: :ignore)),
      links: length(get_time_zones(links: :only))
    }
  end

  defp get(key) do
    :persistent_term.get({@key, key})
  end

  defp fetch(key) do
    case :persistent_term.get({@key, key}, :error) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  defp fetch(key, sub_key) do
    with {:ok, map} <- fetch(key) do
      Map.fetch(map, sub_key)
    end
  end

  defp fetch_transitions_by_link(_link, true), do: {:error, :transitions_not_found}

  defp fetch_transitions_by_link(link, false) do
    case fetch(:links, link) do
      {:ok, time_zone} -> fetch_transitions(time_zone, true)
      :error -> {:error, :transitions_not_found}
    end
  end
end
