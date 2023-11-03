defmodule TimeZoneInfo.DataStore.Server do
  @behaviour TimeZoneInfo.DataStore

  use GenServer

  @compile {:inline, fetch_transitions: 3, get_rules: 2}

  @impl true
  def init(_opts), do: {:ok, :empty}

  @impl true
  def put(data) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    GenServer.call(__MODULE__, {:put, data})
  end

  @impl true
  def fetch_transitions(time_zone) do
    GenServer.call(__MODULE__, {:fetch_transitions, time_zone})
  end

  @impl true
  def get_rules(rule_name) do
    GenServer.call(__MODULE__, {:get_rules, rule_name})
  end

  @impl true
  def get_time_zones(links: select) when select in [:ignore, :only, :include] do
    GenServer.call(__MODULE__, {:get_time_zones, select})
  end

  @impl true
  def version do
    GenServer.call(__MODULE__, :version)
  end

  @impl true
  def empty? do
    GenServer.call(__MODULE__, :empty?)
  end

  @impl true
  def delete!, do: :ok

  @impl true
  def handle_call({:put, data}, _from, _state) do
    {:reply, :ok, data}
  end

  def handle_call(
        {:fetch_transitions, time_zone},
        _from,
        %{time_zones: time_zones, links: links} = state
      ) do
    {:reply, fetch_transitions(time_zones, links, time_zone), state}
  end

  def handle_call({:get_rules, rule_name}, _from, %{rules: rules} = state) do
    {:reply, get_rules(rules, rule_name), state}
  end

  def handle_call(
        {:get_time_zones, select},
        _from,
        %{time_zones: time_zones, links: links} = state
      ) do
    time_zones =
      case select do
        :ignore ->
          time_zones |> Map.keys() |> Enum.sort()

        :only ->
          links |> Map.keys() |> Enum.sort()

        :include ->
          time_zones = Map.keys(time_zones)
          links = Map.keys(links)
          time_zones |> Enum.concat(links) |> Enum.sort()
      end

    {:reply, time_zones, state}
  end

  def handle_call(:version, _from, state) do
    version =
      case state do
        :empty -> nil
        data -> Map.get(data, :version)
      end

    {:reply, version, state}
  end

  def handle_call(:empty?, _from, state) do
    {:reply, state == :empty, state}
  end

  defp fetch_transitions(time_zones, links, time_zone) do
    with :error <- Map.fetch(time_zones, time_zone),
         :error <- Map.fetch(time_zones, Map.get(links, time_zone)) do
      {:error, :transitions_not_found}
    end
  end

  defp get_rules(rules, rule_name) do
    with :error <- Map.fetch(rules, rule_name), do: {:error, :rules_not_found}
  end
end
