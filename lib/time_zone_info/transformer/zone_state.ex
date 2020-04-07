defmodule TimeZoneInfo.Transformer.ZoneState do
  @moduledoc """
  The transformer for time-zones.
  """

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil, Transformer}
  alias TimeZoneInfo.Transformer.{Abbr, Rule, RuleSet, Transition}

  @doc """
  Transforms the `IanaPraser.zone` data in a list of `TimeZoneInfo.transition`.
  """
  @spec transform([IanaParser.zone()], IanaParser.output(), Transformer.opts()) :: [
          TimeZoneInfo.transition()
        ]
  def transform(zone_states, data, opts) do
    rule_sets = Rule.to_rule_sets(data[:rules], opts[:lookahead])

    zone_states
    # |> IO.inspect(label: :zone_states)
    |> do_transform(rule_sets)
    |> NaiveDateTimeUtil.sort(:desc)
    # |> IO.inspect(label: :before_check, limit: :infinity)
    |> to_gregorian_seconds()
    # |> check_zone_state_transitions()
    # |> debug(label: :after_check, limit: :infinity)
    # |> strip_rule_names()
    |> delete_duplicates()
    |> add_max_rules(zone_states, data)
  end

  defp debug(list, opts) do
    list
    |> Enum.map(fn {at, info} -> {NaiveDateTimeUtil.from_gregorian_seconds(at), info} end)
    |> IO.inspect(opts)

    list
  end

  defp strip_rule_names(transitions) do
    Enum.map(transitions, fn {at, {_rule_name, info}} -> {at, info} end)
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

  defp last([]), do: nil

  defp last(list), do: hd(list)

  defp transform_zone_state(zone_state, rule_sets, since, std_offset, last_zone_state) do
    IO.inspect("---------------------------------------")
    IO.inspect(zone_state, label: :zone_state)
    IO.inspect(since, label: :since)

    last_utc_offset =
      case last_zone_state do
        nil -> 0
        _ -> last_zone_state[:utc_offset]
      end


    rules = zone_state[:rules]

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
      {_, info} = transition, [{_, info} | tail] = acc -> acc
      {at, _} = transition, [{at, _} | tail] = acc -> acc
      transition, acc -> [transition | acc]
    end)
  end

  defp check_zone_state_transitions(transitions) do
    transitions
    |> Enum.reverse()
    |> check_zone_state_transitions([], nil)

    # |> Enum.reduce({[], nil}, fn
    #  {_, info}, {_, info} = acc -> acc
    #  {_, info} = transition, {list, _} -> {[transition | list], info}
    # end)
    # |> Kernel.elem(0)
  end

  # TODO: last and hd(acc) are the same value. You idiot ;-)

  defp check_zone_state_transitions([], transitions, _), do: transitions

  defp check_zone_state_transitions([transition | transitions], [], nil) do
    check_zone_state_transitions(transitions, [transition], transition)
  end

  defp check_zone_state_transitions(
         [{at_a, {rule_name_a, info_a}} = transition | transitions],
         acc,
         {at_b, {rule_name_b, info_b}} = last
       ) do
    cond do
      to_wall(at_a, info_b) == to_wall(at_b, info_a) ||
          to_wall(at_a, info_a) == to_wall(at_b, info_b) ->

        case rule_name_a do
          :std_offset ->
            tail = tl(acc)
            check_zone_state_transitions(transitions, [transition | tail], transition)

          _ ->
            tail = tl(acc)
            new = {at_b, {rule_name_a, info_a}}
            # check_zone_state_transitions(transitions, [ new| tail], new)
            check_zone_state_transitions(transitions, [new | tail], hd(tail))
        end

      to_wall(at_a, info_a) == to_wall(at_b, info_b) ->
        check_zone_state_transitions(transitions, [transition | acc], transition)

      true ->
        check_zone_state_transitions(transitions, [transition | acc], transition)
    end
  end

  defp utc_offset_diff({_at, {_rule_nam, {utc_offset, _std_offset, _zone_abbr}}}) do
    {utc_offset, 0}
  end

  defp to_wall(at, {utc_offset, std_offset, _}), do: at + utc_offset + std_offset

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
    } |> IO.inspect()
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
    } |> IO.inspect()
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

    # raise "up to here"
    # until = NaiveDateTimeUtil.to_utc(until, time_standard, utc_offset)
    # transitions = RuleSet.transitions(rule_set, since, until, utc_offset, last, format)

    # {transitions, until} = check(transitions, until, time_standard)

    # until = until_update(until, time_standard, transitions)

    # IO.inspect({Enum.take(transitions, -2), until}, label: :foo)

    # {transitions, until}
  end

  defp check(transitions, until, time_standard) do
    # until = until_update(until, time_standard, transitions)
    # TODO: maybe obsolete after rerererefactoing

    case Enum.reverse(transitions) do
      [{_at, info}] = transitions ->
        until = until_update(until, time_standard, info)
        {transitions, until}

      [{at_last, last}, {at_before, before} | rest] = transitions ->
        until_before = until_update(until, time_standard, before)
        until_last = until_update(until, time_standard, last)

        # IO.inspect([last, before, until], label: :chex)
        # until = NaiveDateTime.add(until, get_std_offset(last) * -1)

        case NaiveDateTimeUtil.before?(at_last, until_before) do
          true ->
            {transitions, until_last}

          false ->
            {[{at_before, before} | rest], until_before}
        end
    end
  end

  defp until_update(until, time_standard, info)
       when time_standard in [:standard, :utc, :gmt, :zulu],
       do: until

  defp until_update(until, _, info) do
    NaiveDateTime.add(until, get_std_offset(info) * -1)
  end

  defp get_last_std_offset(transitions) do
    transitions |> List.last() |> get_std_offset()
  end

  # TODO: remove?
  defp get_std_offset({_at, {_rule_name, {_utc_offset, std_offset, _abbr}}}),
    do: std_offset

  defp get_std_offset({_rule_name, {_utc_offset, std_offset, _abbr}}),
    do: std_offset

  defp until_from_iana(nil), do: ~N[9999-12-31 00:00:00]

  defp until_from_iana(datetime), do: NaiveDateTimeUtil.from_iana(datetime)

  defp rules(data, name) do
    with {:ok, name} <- rule_name(name) do
      get_in(data, [:rules, name])
    end
  end

  defp rule_set(rule_sets, name) do
    # IO.inspect(name, label: :rule_set_name)
    with {:ok, name} <- rule_name(name) do
      Map.fetch!(rule_sets, name)
    end
  end

  defp rule_name(nil), do: :none
  defp rule_name(value) when is_integer(value), do: {:std_offset, value}
  defp rule_name(string), do: {:ok, string}
end
