defmodule TimeZoneInfo.Transformer.ZoneState do
  @moduledoc """
  The transformer for time-zones.
  """

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil, Transformer}
  alias TimeZoneInfo.Transformer.{Abbr, Rule, RuleSet}

  @doc """
  Transforms the `IanaPraser.zone` data in a list of `TimeZoneInfo.transition`.
  """
  @spec transform([IanaParser.zone()], IanaParser.output(), Transformer.opts()) :: [
          TimeZoneInfo.transition()
        ]
  def transform(zone_states, data, opts) do
    rule_sets = Rule.to_rule_sets(data[:rules], opts[:lookahead])

    zone_states
    |> do_transform(rule_sets)
    |> NaiveDateTimeUtil.sort(:desc)
    |> to_gregorian_seconds()
    |> delete_duplicates()
    |> add_max_rules(zone_states, data)
  end

  defp do_transform(zone_states, rule_sets) do
    do_transform(zone_states, rule_sets, ~N[0000-01-01 00:00:00], 0, nil, [])
  end

  defp do_transform([], _rule_sets, _since, _std_offset, _last_zone_state, acc),
    do: List.flatten(acc)

  defp do_transform(
         [zone_state | zone_states],
         rule_sets,
         since,
         std_offset,
         last_zone_state,
         acc
       ) do
    {result, until, last_std_offset} =
      transform_zone_state(zone_state, rule_sets, since, std_offset, last_zone_state)

    do_transform(zone_states, rule_sets, until, last_std_offset, zone_state, [result | acc])
  end

  defp transform_zone_state(zone_state, rule_sets, since, std_offset, last_zone_state) do
    last_utc_offset =
      case last_zone_state do
        nil -> 0
        _ -> last_zone_state[:utc_offset]
      end

    transitions(
      rule_set(rule_sets, zone_state[:rules]),
      since,
      zone_state,
      last_utc_offset,
      std_offset
    )
  end

  def until(zone_state, std_offset) do
    case zone_state[:until] do
      nil ->
        ~N[9999-12-31 00:00:00]

      until ->
        until
        |> NaiveDateTimeUtil.from_iana()
        |> NaiveDateTimeUtil.to_utc(
          zone_state[:time_standard],
          zone_state[:utc_offset],
          std_offset
        )
    end
  end

  defp delete_duplicates(transitions) do
    transitions
    |> Enum.reverse()
    |> Enum.reduce([], fn
      transition, [] -> [transition]
      {_, info}, [{_, info} | _] = acc -> acc
      {at, _}, [{at, _} | _] = acc -> acc
      transition, acc -> [transition | acc]
    end)
  end

  defp add_max_rules(transitions, zone_states, data) do
    zone_states
    |> max_rules(data)
    |> add_rules(transitions)
  end

  defp max_rules(zone_states, data) do
    zone_state = List.last(zone_states)
    rules = zone_state[:rules]

    case data |> rules(rules) |> Rule.max?() do
      true -> {zone_state[:utc_offset], rules, zone_state[:format]}
      false -> :no_max_rules
    end
  end

  defp add_rules(:no_max_rules, transitions), do: transitions

  defp add_rules(rules, [{at, _info} | transitions]), do: [{at, rules} | transitions]

  defp to_gregorian_seconds(transitions) do
    Enum.map(transitions, fn {at, info} ->
      {NaiveDateTimeUtil.to_gregorian_seconds(at), info}
    end)
  end

  defp transitions(
         :none,
         since,
         zone_state,
         _last_utc_offset,
         _std_offset
       ) do
    utc_offset = zone_state[:utc_offset]
    std_offset = 0
    zone_abbr = Abbr.create(zone_state[:format])

    {
      [{since, {utc_offset, std_offset, zone_abbr}}],
      until(zone_state, std_offset),
      std_offset
    }
  end

  defp transitions(
         {:std_offset, std_offset},
         since,
         zone_state,
         _last_utc_offset,
         _
       ) do
    utc_offset = zone_state[:utc_offset]
    zone_abbr = Abbr.create(zone_state[:format], std_offset)

    {
      [{since, {utc_offset, std_offset, zone_abbr}}],
      until(zone_state, std_offset),
      std_offset
    }
  end

  defp transitions(
         rule_set,
         since,
         zone_state,
         last_utc_offset,
         std_offset
       ) do
    RuleSet.new_transitions(
      rule_set,
      since,
      zone_state,
      last_utc_offset,
      std_offset
    )
  end

  defp rules(data, name) do
    with {:ok, name} <- rule_name(name) do
      get_in(data, [:rules, name])
    end
  end

  defp rule_set(rule_sets, name) do
    with {:ok, name} <- rule_name(name) do
      Map.fetch!(rule_sets, name)
    end
  end

  defp rule_name(nil), do: :none
  defp rule_name(value) when is_integer(value), do: {:std_offset, value}
  defp rule_name(string), do: {:ok, string}
end
