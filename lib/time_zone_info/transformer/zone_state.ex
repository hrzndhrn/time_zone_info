defmodule TimeZoneInfo.Transformer.ZoneState do
  @moduledoc """
  The transformer for time-zones.
  """

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil, Transformer}
  alias TimeZoneInfo.Transformer.{Abbr, Rule, Transition}

  @doc """
  Transforms the `IanaPraser.zone` data in a list of `TimeZoneInfo.transition`.
  """
  @spec transform([IanaParser.zone()], IanaParser.output(), Transformer.opts()) :: [
          TimeZoneInfo.transition()
        ]
  def transform(zone_states, data, opts) do
    zone_states
    |> do_transform(data, opts)
    |> delete_duplicates()
    |> to_gregorian_seconds()
    |> add_max_rules(zone_states, data)
  end

  defp do_transform(zone_states, data, opts) do
    do_transform(zone_states, data, [], ~N[0000-01-01 00:00:00], nil, opts)
  end

  defp do_transform([], _data, acc, _since, _last_zone_state, _opts), do: List.flatten(acc)

  defp do_transform([zone_state | zone_states], data, acc, since, last_zone_state, opts) do
    {result, until} = do_transform_zone_state(zone_state, data, since, last_zone_state, opts)

    do_transform(zone_states, data, [result | acc], until, zone_state, opts)
  end

  defp do_transform_zone_state(zone_state, data, since, last_zone_state, opts) do
    transitions(
      rules(data, zone_state[:rules]),
      since,
      until(zone_state[:until], opts),
      zone_state[:utc_offset],
      zone_state[:time_standard],
      zone_state[:format],
      last_zone_state[:utc_offset]
    )
  end

  defp delete_duplicates(transitions) do
    transitions
    |> Enum.reverse()
    |> Enum.reduce({[], nil}, fn
      {_, info}, {_, info} = acc -> acc
      {_, info} = transition, {list, _} -> {[transition | list], info}
    end)
    |> Kernel.elem(0)
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

  defp transitions(:none, since, until, utc_offset, time_standard, format, _) do
    {
      [{since, {utc_offset, 0, Abbr.create(format)}}],
      NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset)
    }
  end

  defp transitions({:std_offset, std_offset}, since, until, utc_offset, time_standard, format, _) do
    {
      [{since, {utc_offset, std_offset, Abbr.create(format)}}],
      NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset, std_offset)
    }
  end

  defp transitions(rules, since, until, utc_offset, time_standard, format, last_utc_offset) do
    until = NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset)
    transitions = Rule.transitions(rules, since, until, utc_offset, last_utc_offset, format)

    until =
      case time_standard do
        :standard -> until
        _ -> NaiveDateTime.add(until, Transition.get_std_offset(transitions) * -1)
      end

    transitions = Transition.transform(transitions)

    {transitions, until}
  end

  defp until(nil, opts) do
    %NaiveDateTime{year: year} = NaiveDateTime.utc_now()
    NaiveDateTimeUtil.end_of_year(year + opts[:lookahead])
  end

  defp until(datetime, _opts), do: NaiveDateTimeUtil.from_iana(datetime)

  defp rules(_data, nil), do: :none

  defp rules(_data, std_offset) when is_integer(std_offset), do: {:std_offset, std_offset}

  defp rules(data, name), do: get_in(data, [:rules, name])
end
