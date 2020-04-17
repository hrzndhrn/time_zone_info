defmodule TimeZoneInfo.DataStore.PersistentTerm do
  if function_exported?(:persistent_term, :get, 0) do
    @moduledoc false
    # This module implements the `TimeZoneInfo.DataStore` and stores the data with
    # [:persistent_term](https://erlang.org/doc/man/persistent_term.html).

    @behaviour TimeZoneInfo.DataStore

    @app :time_zone_info

    @impl true
    def put(data) do
      put_time_zone_info(data)
      put_transitions(data)
      put_rules(data)
      put_links(data)
      put_time_zones(data)
    end

    @impl true
    def get_transitions(time_zone, link \\ false) do
      case :persistent_term.get({@app, :transitions, time_zone}, :not_found) do
        :not_found ->
          case link do
            true -> {:error, :transitions_not_found}
            false -> time_zone |> get_link() |> get_transitions(true)
          end

        transitions ->
          {:ok, transitions}
      end
    end

    @impl true
    def get_rules(rules) do
      case :persistent_term.get({@app, :rules, rules}, :not_found) do
        :not_foudn -> {:error, :rules_not_found}
        rules -> {:ok, rules}
      end
    end

    @impl true
    def get_time_zones(links: select) when select in [:ignore, :only, :include] do
      with %{time_zones: time_zones, links: links, all: all} <-
             :persistent_term.get({@app, :time_zones}, []) do
        case select do
          :ignore -> time_zones
          :only -> links
          :include -> all
        end
      end
    end

    @impl true
    def empty? do
      case version() do
        nil -> true
        _ -> false
      end
    end

    @impl true
    def version do
      :persistent_term.get({@app, :version}, nil)
    end

    @impl true
    def delete! do
      :persistent_term.get()
      |> Enum.map(&elem(&1, 0))
      |> Enum.filter(fn
        key when is_tuple(key) -> elem(key, 0) == @app
        _ -> false
      end)
      |> Enum.each(fn key ->
        :persistent_term.erase(key)
      end)
    end

    @impl true
    def info do
      {count, memory} =
        :persistent_term.get()
        |> Enum.reduce({0, 0}, fn {key, value}, {count, memory} = acc ->
          case is_tuple(key) && elem(key, 0) == @app do
            true -> {count + 1, memory + memory(key) + memory(value)}
            false -> acc
          end
        end)

      %{
        version: version(),
        count: count,
        memory: memory,
        time_zones: length(get_time_zones(links: :ignore)),
        links: length(get_time_zones(links: :only))
      }
    end

    defp memory(value), do: value |> :erlang.term_to_binary() |> byte_size()

    defp put_time_zone_info(data) do
      version = Map.get(data, :version)
      :persistent_term.put({@app, :version}, version)
    end

    defp put_transitions(data) do
      data
      |> Map.get(:time_zones, %{})
      |> Enum.each(fn {time_zone, transitions} ->
        :persistent_term.put({@app, :transitions, time_zone}, transitions)
      end)
    end

    defp put_rules(data) do
      data
      |> Map.get(:rules, %{})
      |> Enum.each(fn {name, rules} ->
        :persistent_term.put({@app, :rules, name}, rules)
      end)
    end

    defp put_links(data) do
      data
      |> Map.get(:links, %{})
      |> Enum.each(fn {from, to} ->
        :persistent_term.put({@app, :link, from}, to)
      end)
    end

    defp put_time_zones(data) do
      time_zones = data |> Map.get(:time_zones) |> Map.keys() |> Enum.sort()
      links = data |> Map.get(:links) |> Map.keys() |> Enum.sort()
      all = time_zones |> Enum.concat(links) |> Enum.sort()
      data = %{time_zones: time_zones, links: links, all: all}
      :persistent_term.put({@app, :time_zones}, data)
    end

    defp get_link(time_zone), do: :persistent_term.get({@app, :link, time_zone}, :not_found)
  end
end
