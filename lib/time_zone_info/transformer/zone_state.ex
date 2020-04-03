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
    |> IO.inspect(label: :zone_states)
    |> do_transform(data, opts)
    |> IO.inspect(label: :before_del, limit: :infinity)
    |> to_gregorian_seconds()
    |> delete_duplicates()
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
    IO.inspect("---------------------------------------")
    IO.inspect(zone_state, label: :zone_state)
    IO.inspect({since, until(zone_state[:until], opts)})

    last =
      case last_zone_state do
        nil ->
          nil

        last ->
          [
            utc_offset: last_zone_state[:utc_offset],
            rules: last_zone_state[:rules],
            new_rules: zone_state[:rules] != last_zone_state[:rules]
          ]
      end

    transitions(
      rules(data, zone_state[:rules]),
      since,
      until(zone_state[:until], opts),
      zone_state[:utc_offset],
      zone_state[:time_standard],
      zone_state[:format],
      last
    )
  end

  defp delete_duplicates(transitions) do
    transitions
    |> Enum.reverse()
    |> delete_duplicates([], nil)

    # |> Enum.reduce({[], nil}, fn
    #  {_, info}, {_, info} = acc -> acc
    #  {_, info} = transition, {list, _} -> {[transition | list], info}
    # end)
    # |> Kernel.elem(0)
  end

  defp delete_duplicates([], transitions, _), do: transitions

  defp delete_duplicates([transition | transitions], [], nil) do
    delete_duplicates(transitions, [transition], transition)
  end

  defp delete_duplicates([{_, info} = transition | transitions], acc, {_, info}) do
    delete_duplicates(transitions, acc, transition)
  end

  defp delete_duplicates([{_,info} = transition | transitions], acc, {at,_} = last) do
    case to_wall(transition) == to_wall(last) do
      true ->
        IO.inspect({transition, last}, label: :delete_duplicates_del)
        new = {at, info}
        acc = Enum.drop(acc, 1)
        delete_duplicates(transitions, [new | acc], new)

      false ->
        delete_duplicates(transitions, [transition | acc], transition)
    end
  end

  defp to_wall({at, {utc_offset, std_offset, _}}), do: at + utc_offset + std_offset

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
      [{since, {utc_offset, std_offset, Abbr.create(format, std_offset)}}],
      # NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset, std_offset)
      NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset, std_offset)
    }
  end

  defp transitions(rules, since, until, utc_offset, time_standard, format, last) do
    until = NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset)
    transitions = Rule.transitions(rules, since, until, utc_offset, last, format)

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
