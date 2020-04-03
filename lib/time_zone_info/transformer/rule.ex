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
          last :: Calendar.utc_offset() | nil,
          format :: TimeZoneInfo.zone_abbr_format()
        ) :: [Transition.t()]
  def transitions(rules, since, until, utc_offset, last, format) do
    last = with nil <- last, do: [utc_offset: utc_offset, rules: "", new_rules: true]
    utc_offset_diff = utc_offset - last[:utc_offset]

    rules
    |> Enum.flat_map(fn rule -> do_transitions(rule, since, until, format, utc_offset) end)
    |> to_standard(utc_offset)
    |> NaiveDateTimeUtil.sort(:desc)
    |> Enum.filter(fn {at, _} -> NaiveDateTimeUtil.before?(at, until) end)
    |> IO.inspect(label: :res_all, limit: :infinity)
    # |> delete_duplicates()
    # |> IO.inspect(label: :res)
    |> adjust(since, until, utc_offset_diff, last[:new_rules])
    |> IO.inspect(label: :adjust, limit: :infinity)
    |> case do
      [{^since, _} | _] = transitions ->
        IO.inspect(:ok, label: :after_adjust)
        transitions

      transitions ->
        case is_integer(last[:rules]) do
          true ->
            IO.inspect(:update, label: :after_adjust)
            Transition.update(transitions, last[:rules])

          false ->
            abbr = Abbr.create(format, 0, std_letters(rules))
            # Transition.add_new({since, {utc_offset, 0, :utc, abbr}}, transitions)
            info = {utc_offset, 0, :utc, abbr}
            IO.inspect({since, info}, label: :after_adjust_add)
            [{since, info} | transitions]
            Transition.add_new({since, info}, transitions)
        end
    end
    |> IO.inspect(label: :after_all_adjust, limit: :infinity)
  end

  defp xyz(transitions) do
    transitions
  end

  defp adjust(transitions, since, until, utc_offset_diff, new_rules, acc \\ [])

  defp adjust([], _, _, _, _, acc), do: acc

  defp adjust([{at, info} | transitions], since, until, utc_offset_diff, new_rules, acc) do
    last_at = NaiveDateTime.add(at, utc_offset_diff)

    case !new_rules && utc_offset_diff != 0 && last_at == since do
      true ->
        IO.inspect({at, info}, label: :update_in_adjust)
        IO.inspect(new_rules, label: :new_rules)
        # TODO: raise "do we need this"
        acc
        # adjust(transitions, since, until, utc_offset_diff, new_rules, acc)
        Transition.add_new({since, info}, acc)

      # acc

      false ->
        case NaiveDateTimeUtil.before_or_equal?(at, since) do
          true ->
            # case utc_offset_diff == 0 do
            #  trueue -> Transition.add_new({since, info}, acc)
            #  false -> acc
            # end
            # Transition.add_new({since, info}, acc)
            case new_rules do
              true -> acc
              false -> [{since, info} | acc]
            end

            # check if it the same
            IO.inspect(last_at, label: :last_at__________)

            IO.inspect(at, label: :at)
            IO.inspect(since, label: :since)
            IO.inspect(utc_offset_diff, label: :utc_offset_diff)
            [{since, info} | acc]
            Transition.add_new({since, info}, acc)

          # acc

          false ->
            IO.inspect(last_at, label: :last_last___________)
            case last_at == since do
              true -> [{since, info} | acc]
              false ->
            adjust(transitions, since, until, utc_offset_diff, new_rules, [{at, info} | acc])
            end
        end
    end
  end

  defp do_transitions(rule, since, %NaiveDateTime{} = until, format, utc_offset) do
    case fire?(since, until, rule) do
      true ->
        IO.inspect("-----")
        IO.inspect(rule, label: :rule)
        IO.inspect({since, until})
        from = rule[:from]
        to = rule_to(rule) |> min(until.year)

        Enum.map(from..to, fn year -> do_transitions(rule, year, format) end)
        |> IO.inspect(label: :result)

      false ->
        []
    end
  end

  defp rule_to(rule) do
    case rule[:to] do
      :only -> rule[:from]
      :max -> 9999
      to -> to
    end
  end

  defp fire?(since, until, rule) do
    IO.inspect("-- fire --")
    # IO.inspect(rule, label: :rule)
    IO.inspect({since, until})
    from = NaiveDateTimeUtil.from_iana(rule[:from], rule[:in], rule[:on], rule[:at])

    to =
      NaiveDateTimeUtil.from_iana(rule_to(rule), rule[:in], rule[:on], rule[:at])
      |> NaiveDateTimeUtil.end_of_year()

    to = NaiveDateTimeUtil.end_of_year(6666)
    IO.inspect({from, to})
    NaiveDateTimeUtil.overlap?({from, to}, {since, until})
    # |> IO.inspect(label: :fire)
    NaiveDateTimeUtil.before?(from, until)
  end

  defp overlap?({value_a, value_b}, {value_x, value_y}) do
    cond do
      value_b < value_x -> false
      value_a > value_y -> false
      true -> true
    end
  end

  defp time_span(from_year, to_year, rule, utc_offset) do
    from =
      NaiveDateTimeUtil.from_iana(from_year, rule[:in], rule[:on], rule[:at])
      |> NaiveDateTimeUtil.to_utc(rule[:time_standard], utc_offset, rule[:std_offset])

    to =
      case from_year == to_year do
        false ->
          NaiveDateTimeUtil.from_iana(to_year, rule[:in], rule[:on], rule[:at])
          |> NaiveDateTimeUtil.to_utc(rule[:time_standard], utc_offset, rule[:std_offset])

        true ->
          NaiveDateTimeUtil.end_of_year(to_year + 1)
      end

    {from, to}
  end

  defp do_transitions(rule, year, format) do
    {
      NaiveDateTimeUtil.from_iana(year, rule[:in], rule[:on], rule[:at]),
      {rule[:std_offset], rule[:time_standard], Abbr.create(format, rule)}
    }
  end

  defp to_standard(rule_transitions, utc_offset) do
    Enum.map(rule_transitions, fn {datetime, {std_offset, time_standard, abbr}} ->
      standard = NaiveDateTimeUtil.to_utc(datetime, time_standard, utc_offset)

      {standard, {utc_offset, std_offset, time_standard, abbr}}
    end)
  end

  defp delete_duplicates(transitions) do
    transitions
    |> Enum.reduce({[], nil}, fn
      {_, info} = transition, {[_ | rest], info} -> {[transition | rest], info}
      {_, info} = transition, {list, _} -> {[transition | list], info}
    end)
    |> Kernel.elem(0)
  end
end
