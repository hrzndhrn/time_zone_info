defmodule TimeZoneInfo.Transformer.Rule do
  @moduledoc """
  This module handles and transforms the IANA rules.
  """

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil}

  def to_rule_sets(rules, lookahead) do
    Enum.into(rules, %{}, fn {name, rules} ->
      {name, to_rule_set(rules, lookahead)}
    end)
  end

  def to_rule_set(rules, lookahead) do
    now = NaiveDateTime.utc_now()

    rule_set =
      Enum.flat_map(rules, fn rule ->
        from = rule[:from]

        to =
          case rule[:to] do
            :max -> max(now.year + lookahead, from + 1)
            :only -> rule[:from]
            year -> year
          end

        Enum.into(from..to, [], fn year ->
          at = NaiveDateTimeUtil.from_iana(year, rule[:in], rule[:on], rule[:at])
          {at, {rule[:time_standard], rule[:std_offset], rule[:letters]}}
        end)
      end)
      |> NaiveDateTimeUtil.sort()

    {_, first} = first_standard(rule_set)
    [{~N[-0001-01-01 00:00:00], first} | rule_set]
  end

  defp first_standard(rule_set) do
    Enum.find(rule_set, fn
      {_, {_, 0, _}} -> true
      _ -> false
    end)
  end

  @doc """
  Transforms a `IanaParser.rule` to a `TimeZoneInfo.rule`. If the function gets
  a list then all rules will be transformed.
  """
  @spec transform(rule | rules) :: TimeZoneInfo.rule() | [TimeZoneInfo.rule()]
        when rule: IanaParser.rule(), rules: [IanaParser.rule()]
  def transform(rule) when is_list(rule) do
    case Keyword.keyword?(rule) do
      true ->
        {
          {rule[:in], rule[:on], rule[:at]},
          rule[:time_standard],
          rule[:std_offset],
          rule[:letters]
        }

      false ->
        rule |> Enum.map(&transform/1) |> Enum.reverse()
    end
  end

  @doc """
  Returns all rules form the rule set that are for now valid until end of time.
  """
  @spec max([IanaParser.rule()]) :: [IanaParser.rule()]
  def max(rules), do: Enum.filter(rules, &max?/1)

  @doc """
  Returns `true` if `rule` is valid until end of time or one of the `rules` is valid
  until end of time.
  """
  @spec max?(rule | rules) :: boolean when rule: IanaParser.rule(), rules: [IanaParser.rule()]
  def max?(rule_or_rules) when is_list(rule_or_rules) do
    case Keyword.keyword?(rule_or_rules) do
      true -> rule_or_rules[:to] == :max
      false -> Enum.any?(rule_or_rules, &max?/1)
    end
  end

  def max?(_), do: false

  @doc """
  Returns `letters` from the first rule that will produce a transition with
  `std_offset = 0`.
  """
  @spec std_letters([IanaParser.rule()]) :: String.t()
  def std_letters(rules) do
    Enum.find_value(rules, fn rule ->
      case rule[:std_offset] do
        0 -> rule[:letters]
        _ -> false
      end
    end)
  end
end
