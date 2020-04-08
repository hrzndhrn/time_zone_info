defmodule TimeZoneInfo.Transformer.RuleSet do
  @moduledoc """
  A rule set is a set of IANA rules with one entry per rule execution.
  """

  alias TimeZoneInfo.IanaParser
  alias TimeZoneInfo.NaiveDateTimeUtil, as: NaiveDateTime
  alias TimeZoneInfo.Transformer.{Abbr, ZoneState}

  @type rule :: {
          Elixir.NaiveDateTime.t(),
          {TimeZoneInfo.time_standard(), Calendar.std_offset(), Abbr.letters()}
        }
  @type t :: [rule()]

  @doc """
  Generates the transitions for the given `zone_state`.
  """
  @spec transitions(
          t(),
          Elixir.NaiveDateTime.t(),
          IanaParser.zone_state(),
          Calendar.utc_offset(),
          Calendar.std_offset(),
          rule() | nil,
          [TimeZoneInfo.transition()]
        ) :: {
          [TimeZoneInfo.transition()],
          Elixir.NaiveDateTime.t(),
          Calendar.std_offset()
        }
  def transitions(
        rule_set,
        since,
        zone_state,
        last_utc_offset,
        last_std_offset,
        last_rule \\ nil,
        acc \\ []
      )

  def transitions([], since, zone_state, _last_utc_offset, _last_std_offset, last_rule, []) do
    acc = add([], since, zone_state, last_rule)
    std_offset = std_offset(last_rule)
    until = ZoneState.until(zone_state, std_offset)
    {acc, until, std_offset}
  end

  def transitions([], _since, zone_state, _last_utc_offset, last_std_offset, _last_rule, acc) do
    until = ZoneState.until(zone_state, last_std_offset)
    {acc, until, last_std_offset}
  end

  def transitions(
        [rule | rule_set],
        since,
        zone_state,
        last_utc_offset,
        last_std_offset,
        last_rule,
        acc
      ) do
    until = ZoneState.until(zone_state, last_std_offset)
    {at, {std_offset, letters}} = to_utc(rule, zone_state, last_std_offset)
    position(at, since, until)

    case position(at, since, until) do
      :before ->
        transitions(rule_set, since, zone_state, last_utc_offset, last_std_offset, rule, acc)

      :start ->
        acc = add(acc, at, zone_state, std_offset, letters)
        transitions(rule_set, since, zone_state, last_utc_offset, std_offset, rule, acc)

      :inside ->
        acc =
          cond do
            start?(since, at, zone_state, last_utc_offset) ->
              add(acc, since, zone_state, std_offset, letters)

            start?(since, at, std_offset) ->
              add(acc, since, zone_state, std_offset, letters)

            Enum.empty?(acc) ->
              since_wall = to_wall(since, zone_state, last_rule)
              at_wall = to_wall(at, zone_state, std_offset)

              case since_wall == at_wall do
                true ->
                  add(acc, since, zone_state, std_offset, letters)

                false ->
                  {at, _} = to_utc(rule, zone_state, std_offset(last_rule))

                  acc
                  |> add(since, zone_state, last_rule)
                  |> add(at, zone_state, std_offset, letters)
              end

            true ->
              add(acc, at, zone_state, std_offset, letters)
          end

        transitions(rule_set, since, zone_state, last_utc_offset, std_offset, rule, acc)

      :after ->
        case Enum.empty?(acc) do
          true ->
            acc = add(acc, since, zone_state, last_rule)
            std_offset = std_offset(last_rule)
            until = ZoneState.until(zone_state, std_offset)
            {acc, until, std_offset}

          false ->
            {acc, until, last_std_offset}
        end
    end
  end

  @doc """
  Generates transitions for the given `rule_set`.
  """
  @spec transitions(t(), Calendar.utc_offset(), Abbr.format()) ::
          [TimeZoneInfo.transition()]
  def transitions(rule_set, utc_offset, format),
    do: transitions_seq(rule_set, utc_offset, format)

  @spec transitions_seq(
          t(),
          Calendar.utc_offset(),
          Abbr.format(),
          Calendar.std_offset(),
          [TimeZoneInfo.transition()]
        ) :: [TimeZoneInfo.transition()]
  defp transitions_seq(rule_set, utc_offset, format, last_std_offset \\ 0, acc \\ [])

  defp transitions_seq([], _utc_offset, _format, _last_std_offset, acc), do: acc

  defp transitions_seq([rule | rule_set], utc_offset, format, last_std_offset, acc) do
    {at, {std_offset, letters}} = to_utc(rule, utc_offset, last_std_offset)
    zone_abbr = Abbr.create(format, std_offset, letters)
    transition = {at, {utc_offset, std_offset, zone_abbr}}
    transitions_seq(rule_set, utc_offset, format, std_offset, [transition | acc])
  end

  defp std_offset({_at, {_, std_offset, _}}), do: std_offset

  defp start?(since, at, std_offset) do
    since == NaiveDateTime.add(at, std_offset * -1)
  end

  defp start?(since, at, zone_state, last_utc_offset) do
    utc_offset_diff = zone_state[:utc_offset] - last_utc_offset
    since == NaiveDateTime.add(at, utc_offset_diff)
  end

  defp add(transitions, at, zone_state, {_at, {_, std_offset, letters}}) do
    add(transitions, at, zone_state, std_offset, letters)
  end

  defp add(transitions, at, zone_state, std_offset, letters) do
    utc_offset = zone_state[:utc_offset]
    format = zone_state[:format]
    zone_abbr = Abbr.create(format, std_offset, letters)
    transition = {at, {utc_offset, std_offset, zone_abbr}}
    [transition | transitions]
  end

  defp to_wall(at, zone_state, {_, {_, std_offset, _}}) do
    to_wall(at, zone_state, std_offset)
  end

  defp to_wall(at, zone_state, std_offset) do
    utc_offset = zone_state[:utc_offset]
    NaiveDateTime.add(at, utc_offset + std_offset)
  end

  defp to_utc({at, {time_standard, std_offset, letters}}, utc_offset, last_std_offset)
       when is_integer(utc_offset) do
    at = NaiveDateTime.to_utc(at, time_standard, utc_offset, last_std_offset)
    {at, {std_offset, letters}}
  end

  defp to_utc({at, {time_standard, std_offset, letters}}, zone_state, last_std_offset) do
    utc_offset = zone_state[:utc_offset]
    at = NaiveDateTime.to_utc(at, time_standard, utc_offset, last_std_offset)
    {at, {std_offset, letters}}
  end

  defp position(at, at, _), do: :start

  defp position(at, since, until) do
    case {NaiveDateTime.before?(at, since), NaiveDateTime.before?(at, until)} do
      {_, false} -> :after
      {true, _} -> :before
      _ -> :inside
    end
  end
end