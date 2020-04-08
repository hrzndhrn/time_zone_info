defmodule TimeZoneInfo.Transformer.ZoneState do
  @moduledoc """
  The transformer for time-zones.
  """

  alias TimeZoneInfo.IanaParser
  alias TimeZoneInfo.NaiveDateTimeUtil, as: NaiveDateTime
  alias TimeZoneInfo.Transformer
  alias TimeZoneInfo.Transformer.{Abbr, Rule, RuleSet}

  @doc """
  Transforms the `IanaPraser.zone` data in a list of `TimeZoneInfo.transition`.
  """
  @spec transform([IanaParser.zone_state()], IanaParser.output(), Transformer.opts()) ::
          [TimeZoneInfo.transition()]
  def transform(zone_states, data, opts) do
    rule_sets = Rule.to_rule_sets(data[:rules], opts[:lookahead])

    zone_states
    |> transform_zone_states(rule_sets)
    |> to_gregorian_seconds()
    |> delete_duplicates()
    |> add_max_rules(zone_states, data)
  end

  @doc """
  Returns the until datetime for the given `zone_state` and `std_offset`.
  """
  @spec until(IanaParser.zone_state(), Calendar.std_offset()) :: Elixir.NaiveDateTime.t()
  def until(zone_state, std_offset) do
    case zone_state[:until] do
      nil ->
        ~N[9999-12-31 00:00:00]

      until ->
        until
        |> NaiveDateTime.from_iana()
        |> NaiveDateTime.to_utc(
          zone_state[:time_standard],
          zone_state[:utc_offset],
          std_offset
        )
    end
  end

  defp transform_zone_states(
         zone_states,
         rule_sets,
         since \\ ~N[0000-01-01 00:00:00],
         std_offset \\ 0,
         last_zone_state \\ nil,
         acc \\ []
       )

  defp transform_zone_states([], _, _, _, _, acc), do: List.flatten(acc)

  defp transform_zone_states(
         [zone_state | zone_states],
         rule_sets,
         since,
         std_offset,
         last_zone_state,
         acc
       ) do
    {result, until, last_std_offset} =
      transform_zone_state(zone_state, rule_sets, since, std_offset, last_zone_state)

    transform_zone_states(zone_states, rule_sets, until, last_std_offset, zone_state, [
      result | acc
    ])
  end

  defp transform_zone_state(zone_state, rule_sets, since, std_offset, last_zone_state) do
    transitions(
      rule_set(rule_sets, zone_state[:rules]),
      since,
      zone_state,
      utc_offset(last_zone_state),
      std_offset
    )
  end

  defp transitions(:none, since, zone_state, _, _) do
    utc_offset = zone_state[:utc_offset]
    std_offset = 0
    zone_abbr = Abbr.create(zone_state[:format])

    {
      [{since, {utc_offset, std_offset, zone_abbr}}],
      until(zone_state, std_offset),
      std_offset
    }
  end

  defp transitions({:std_offset, std_offset}, since, zone_state, _, _) do
    utc_offset = zone_state[:utc_offset]
    zone_abbr = Abbr.create(zone_state[:format], std_offset)

    {
      [{since, {utc_offset, std_offset, zone_abbr}}],
      until(zone_state, std_offset),
      std_offset
    }
  end

  defp transitions(rule_set, since, zone_state, last_utc_offset, std_offset) do
    RuleSet.transitions(rule_set, since, zone_state, last_utc_offset, std_offset)
  end

  defp utc_offset(nil), do: 0
  defp utc_offset(zone_state), do: zone_state[:utc_offset]

  defp delete_duplicates(transitions) do
    transitions
    |> Enum.reverse()
    |> Enum.reduce([], fn
      transition, [] -> [transition]
      {_, period}, [{_, period} | _] = acc -> acc
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
  defp add_rules(rules, [{at, _} | transitions]), do: [{at, rules} | transitions]

  defp to_gregorian_seconds(transitions) do
    Enum.map(transitions, fn {at, period} ->
      {NaiveDateTime.to_gregorian_seconds(at), period}
    end)
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
