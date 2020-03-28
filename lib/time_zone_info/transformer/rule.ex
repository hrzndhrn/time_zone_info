defmodule TimeZoneInfo.Transformer.Rule do
  @moduledoc """
  This module handles and transforms the IANA rules.
  """

  alias TimeZoneInfo.{IanaParser, NaiveDateTimeUtil}
  alias TimeZoneInfo.Transformer.{Abbr, Transition}

  @doc """
  Transforms a `IanaParser.rule` to a `TimeZoneInfo.rule`. If the function gets
  a list then all rules will be transformed.
  """
  @spec transform(rule | rules) :: TimeZoneInfo.rule() | [TimeZoneInfo.rule()]
        when rule: IanaParser.rule(), rules: [IanaParser.rule()]
  def transform(rule) when is_list(rule) do
    case Keyword.keyword?(rule) do
      true ->
        {hour, minute, second} = rule[:at]

        {
          {rule[:in], rule[:on], hour, minute, second},
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

  @doc """
  Returns transitions fore the IANA `rules`.
  """
  @spec transitions(
          rules :: [IanaParser.rule()],
          since :: NaiveDateTime.t(),
          until :: NaiveDateTime.t(),
          utc_offset :: Calendar.utc_offset(),
          last_utc_offset :: Calendar.utc_offset() | nil,
          format :: TimeZoneInfo.zone_abbr_format()
        ) :: [Transition.t()]
  def transitions(rules, since, until, utc_offset, last_utc_offset, format) do
    utc_offset_diff =
      case is_nil(last_utc_offset) do
        false -> utc_offset - last_utc_offset
        true -> 0
      end

    rules
    |> Enum.flat_map(fn rule -> do_transitions(rule, since, until, format) end)
    |> to_standard(utc_offset)
    |> NaiveDateTimeUtil.sort(:desc)
    |> adjust(since, until, utc_offset_diff)
    |> case do
      [{^since, _} | _] = transitions ->
        transitions

      transitions ->
        abbr = Abbr.create(format, 0, std_letters(rules))
        Transition.add_new({since, {utc_offset, 0, :utc, abbr}}, transitions)
    end
  end

  defp adjust(transitions, since, until, last_utc_offset, acc \\ [])

  defp adjust([], _, _, _, acc), do: acc

  defp adjust([{at, info} | transitions], since, until, utc_offset_diff, acc) do
    last_at = NaiveDateTime.add(at, utc_offset_diff)

    case utc_offset_diff != 0 && last_at == since do
      true ->
        [{since, info} | acc]

      false ->
        case NaiveDateTimeUtil.before?(at, until) do
          true ->
            case NaiveDateTimeUtil.before?(at, since) do
              true ->
                Transition.add_new({since, info}, acc)

              false ->
                adjust(transitions, since, until, utc_offset_diff, [{at, info} | acc])
            end

          false ->
            adjust(transitions, since, until, utc_offset_diff, acc)
        end
    end
  end

  defp do_transitions(rule, since, %NaiveDateTime{} = until, format) do
    {from_year, to_year} =
      case rule[:to] do
        :only -> {rule[:from], rule[:from]}
        :max -> {rule[:from], until.year}
        to -> {rule[:from], min(to, until.year)}
      end

    case from_year <= to_year do
      false ->
        []

      true ->
        from = NaiveDateTimeUtil.from_iana(from_year, rule[:in], rule[:on], rule[:at])

        to =
          case from_year == to_year do
            false -> NaiveDateTimeUtil.from_iana(to_year, rule[:in], rule[:on], rule[:at])
            true -> NaiveDateTimeUtil.end_of_year(to_year + 1)
          end

        case NaiveDateTimeUtil.overlap?({from, to}, {since, until}) do
          true ->
            Enum.map(from_year..to_year, fn year -> do_transitions(rule, year, format) end)

          false ->
            []
        end
    end
  end

  defp do_transitions(rule, year, format) do
    {
      NaiveDateTimeUtil.from_iana(year, rule[:in], rule[:on], rule[:at]),
      {rule[:std_offset], rule[:time_standard], Abbr.create(format, rule)}
    }
  end

  defp to_standard(rule_transitions, utc_offset) do
    Enum.map(rule_transitions, fn {datetime, {std_offset, time_standard, abbr}} ->
      {NaiveDateTimeUtil.to_utc(datetime, time_standard, utc_offset),
       {utc_offset, std_offset, time_standard, abbr}}
    end)
  end
end
