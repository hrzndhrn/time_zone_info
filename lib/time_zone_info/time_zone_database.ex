defmodule TimeZoneInfo.TimeZoneDatabase do
  @moduledoc """
  Implementation of the `Calendar.TimeZoneDatabase` behaviour.
  """

  alias TimeZoneInfo.{
    DataStore,
    GregorianSeconds,
    IanaDateTime,
    IsoDays,
    Transformer.RuleSet
  }

  @behaviour Calendar.TimeZoneDatabase

  @compile {:inline, gap: 2, convert: 1, to_wall: 1, to_wall: 2}

  @impl true
  def time_zone_periods_from_wall_datetime(_, "Etc/UTC"),
    do: {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "UTC", wall_period: {:min, :max}}}

  def time_zone_periods_from_wall_datetime(
        %NaiveDateTime{calendar: Calendar.ISO} = naive_datetime,
        time_zone
      ) do
    naive_datetime
    |> GregorianSeconds.from_naive()
    |> periods_from_wall_gregorian_seconds(time_zone, naive_datetime)
  end

  def time_zone_periods_from_wall_datetime(%NaiveDateTime{} = naive_datetime, time_zone) do
    naive_datetime
    |> NaiveDateTime.convert!(Calendar.ISO)
    |> time_zone_periods_from_wall_datetime(time_zone)
  end

  @impl true
  def time_zone_period_from_utc_iso_days(_, "Etc/UTC"),
    do: {:ok, %{std_offset: 0, utc_offset: 0, zone_abbr: "UTC", wall_period: {:min, :max}}}

  def time_zone_period_from_utc_iso_days(iso_days, time_zone) do
    iso_days
    |> IsoDays.to_gregorian_seconds()
    |> period_from_utc_gregorian_seconds(time_zone, iso_days)
  end

  defp periods_from_wall_gregorian_seconds(at_wall_seconds, time_zone, at_wall_date_time) do
    case DataStore.get_transitions(time_zone) do
      {:ok, transitions} ->
        transitions
        |> find_transitions(at_wall_seconds)
        |> to_periods(at_wall_seconds, at_wall_date_time)

      {:error, :transitions_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp period_from_utc_gregorian_seconds(gregorian_seconds, time_zone, date_time) do
    case DataStore.get_transitions(time_zone) do
      {:ok, transitions} ->
        transitions
        |> find_transition(gregorian_seconds)
        |> to_period(date_time)

      {:error, :transitions_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp find_transition(transitions, timestamp) do
    Enum.find_value(transitions, fn {at, period} ->
      with true <- at <= timestamp, do: period
    end)
  end

  defp find_transitions([{at_utc, _} = transition | transitions], at_wall, last \\ :none) do
    case at_utc > at_wall do
      false -> {head(transitions, :none), transition, last}
      true -> find_transitions(transitions, at_wall, transition)
    end
  end

  defp head([], default), do: default

  defp head(list, _), do: hd(list)

  defp to_period(
         {utc_offset, rule_name, {_, _} = format},
         {_, {_, _}} = iso_days
       ) do
    case DataStore.get_rules(rule_name) do
      {:ok, rules} ->
        rules
        |> transitions(utc_offset, format, IsoDays.to_year(iso_days))
        |> find_transition(IsoDays.to_gregorian_seconds(iso_days))
        |> to_period(nil)

      {:error, :rules_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp to_period({utc_offset, std_offset, zone_abbr, wall_period}, _) do
    {:ok,
     %{
       utc_offset: utc_offset,
       std_offset: std_offset,
       zone_abbr: zone_abbr,
       wall_period: wall_period
     }}
  end

  defp to_periods({:none, {_at, {utc_offset, std_offset, zone_abbr, _wall_period}}, :none}, _, _) do
    {:ok,
     %{
       utc_offset: utc_offset,
       std_offset: std_offset,
       zone_abbr: zone_abbr,
       wall_period: {:min, :max}
     }}
  end

  defp to_periods({:none, a, b}, at_wall, at_wall_datetime) do
    to_periods({a, b}, at_wall, at_wall_datetime)
  end

  defp to_periods({a, b, :none}, at_wall, at_wall_datetime) do
    to_periods({a, b}, at_wall, at_wall_datetime)
  end

  defp to_periods(
         {_transition, {_, {utc_offset, rule_name, format}}},
         at_wall,
         at_wall_datetime
       )
       when is_binary(rule_name) do
    calculate_periods(utc_offset, rule_name, format, at_wall, at_wall_datetime)
  end

  defp to_periods({transition_a, transition_b}, at_wall, _at_wall_datetime) do
    at_wall_b = to_wall(transition_b)
    at_wall_ba = to_wall(transition_b, transition_a)

    cond do
      at_wall_b <= at_wall && at_wall < at_wall_ba ->
        {:ambiguous, convert(transition_a), convert(transition_b)}

      at_wall_ba <= at_wall && at_wall < at_wall_b ->
        gap(transition_a, transition_b)

      at_wall < at_wall_b ->
        {:ok, convert(transition_a)}

      true ->
        {:ok, convert(transition_b)}
    end
  end

  defp to_periods(
         {_transition_a, _transition_b, {_, {utc_offset, rule_name, format}}},
         at_wall,
         at_wall_datetime
       )
       when is_binary(rule_name) and is_integer(utc_offset) do
    calculate_periods(utc_offset, rule_name, format, at_wall, at_wall_datetime)
  end

  defp to_periods({transition_a, transition_b, transition_c}, at_wall, _at_wall_datetime) do
    at_wall_ba = to_wall(transition_b, transition_a)
    at_wall_b = to_wall(transition_b)
    at_wall_cb = to_wall(transition_c, transition_b)
    at_wall_c = to_wall(transition_c)

    cond do
      at_wall >= at_wall_c ->
        if at_wall < at_wall_cb,
          do: {:ambiguous, convert(transition_b), convert(transition_c)},
          else: {:ok, convert(transition_c)}

      at_wall >= at_wall_cb ->
        gap(transition_b, transition_c)

      at_wall >= at_wall_b ->
        if at_wall < at_wall_ba,
          do: {:ambiguous, convert(transition_a), convert(transition_b)},
          else: {:ok, convert(transition_b)}

      at_wall >= at_wall_ba ->
        gap(transition_a, transition_b)

      true ->
        {:ok, convert(transition_a)}
    end
  end

  defp calculate_periods(utc_offset, rule_name, format, at_wall_seconds, at_wall_datetime) do
    case DataStore.get_rules(rule_name) do
      {:ok, rules} ->
        rules
        |> transitions(utc_offset, format, at_wall_datetime.year)
        |> find_transitions(at_wall_seconds)
        |> to_periods(at_wall_seconds, at_wall_datetime)

      {:error, :rules_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp transitions(rules, utc_offset, format, year) do
    rules
    |> to_rule_set(year)
    |> RuleSet.transitions(utc_offset, format)
  end

  @spec to_rule_set([TimeZoneInfo.rule()], Calendar.year()) :: [TimeZoneInfo.transition()]
  defp to_rule_set(rules, year) do
    Enum.flat_map(rules, fn {{month, day, time}, time_standard, std_offset, letters} ->
      Enum.into((year - 1)..(year + 1), [], fn year ->
        at = IanaDateTime.to_gregorian_seconds(year, month, day, time)

        {at, {time_standard, std_offset, letters}}
      end)
    end)
    |> Enum.sort_by(fn {at, _} -> at end)
  end

  defp gap(
         {_, {utc_offset_a, std_offset_a, zone_abbr_a, {_, limit_a} = wall_period_a}},
         {_, {utc_offset_b, std_offset_b, zone_abbr_b, {limit_b, _} = wall_period_b}}
       ) do
    {
      :gap,
      {
        %{
          utc_offset: utc_offset_a,
          std_offset: std_offset_a,
          zone_abbr: zone_abbr_a,
          wall_period: wall_period_a
        },
        limit_a
      },
      {
        %{
          utc_offset: utc_offset_b,
          std_offset: std_offset_b,
          zone_abbr: zone_abbr_b,
          wall_period: wall_period_b
        },
        limit_b
      }
    }
  end

  defp to_wall({at, {utc_offset, std_offset, _zone_abbr, _wall_period}}),
    do: at + utc_offset + std_offset

  defp to_wall(
         {at, {_, _, _, _}},
         {_, {utc_offset, std_offset, _zone_abbr, _wall_period}}
       ),
       do: at + utc_offset + std_offset

  defp convert({_, {utc_offset, std_offset, zone_abbr, wall_period}}),
    do: %{
      utc_offset: utc_offset,
      std_offset: std_offset,
      zone_abbr: zone_abbr,
      wall_period: wall_period
    }
end
