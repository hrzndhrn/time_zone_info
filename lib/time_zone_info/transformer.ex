defmodule TimeZoneInfo.Transformer do
  @moduledoc """
  The `Transformer` transfers the parsed IANA data into the required format for
  `TimeZoneInfo`.
  """

  alias TimeZoneInfo.{
    IanaParser,
    Transformer.Rule,
    Transformer.ZoneState
  }

  @type opts :: [lookahead: non_neg_integer()]

  @default_opts [lookahead: 15]

  @doc """
  Transforms the `iana_data` into a map of type `TimeZoneInfo.data()`.
  """
  @spec transform(IanaParser.output(), version :: String.t(), opts()) :: TimeZoneInfo.data()
  def transform(iana_data, version, opts \\ @default_opts) do
    time_zones = zones(iana_data, opts)
    rules = rules(iana_data, time_zones)
    links = links(iana_data, time_zones)

    %{time_zones: time_zones, rules: rules, links: links, version: version}
  end

  # Transform IANA zone to TimeZoneInfo time-zones.
  @spec zones(IanaParser.output(), opts()) ::
          %{Calendar.time_zone() => [TimeZoneInfo.transition()]}
  defp zones(iana_data, opts) do
    iana_data
    |> Map.get(:zones, %{})
    |> Enum.into(%{}, fn {name, zone_states} ->
      {name, ZoneState.transform(zone_states, iana_data, opts)}
    end)
  end

  # Transform rules that are required by time zones.
  # These rules are used to determine periods in the future.
  @spec rules(IanaParser.output(), %{Calendar.time_zone() => [TimeZoneInfo.transition()]}) ::
          %{TimeZoneInfo.rule_name() => [TimeZoneInfo.rule()]}
  defp rules(iana_data, time_zones) do
    used_rules = used_rules(time_zones)

    iana_data
    |> Map.get(:rules, %{})
    |> Enum.filter(fn {name, _} -> Enum.member?(used_rules, name) end)
    |> Enum.into(%{}, fn {name, rules} ->
      {name, rules |> Rule.max() |> Rule.transform()}
    end)
  end

  @doc """
  Searching for rules used by time zones.

  A rule can just emit on the head of a transition list.
  """
  @spec used_rules(%{Calendar.time_zone() => [TimeZoneInfo.transition()]}) ::
          [TimeZoneInfo.rule_name()]
  def used_rules(time_zones) do
    time_zones
    |> Enum.reduce([], fn {_time_zone, [{_at, zone_state} | _transitions]}, acc ->
      case zone_state do
        {_, rule_name, _} when is_binary(rule_name) -> [rule_name | acc]
        _ -> acc
      end
    end)
    |> Enum.uniq()
  end

  # Filters out all links that refer to an existing time zone.
  @spec links(IanaParser.output(), %{Calendar.time_zone() => [TimeZoneInfo.transition()]}) ::
          %{Calendar.time_zone() => Calendar.time_zone()}
  defp links(iana_data, time_zones) do
    time_zone_names = Map.keys(time_zones)

    iana_data
    |> Map.get(:links, %{})
    |> Enum.filter(fn {_, name} ->
      Enum.member?(time_zone_names, name)
    end)
    |> Enum.into(%{})
  end
end
