defmodule TimeZoneInfo.TimeZoneDatabase do
  @moduledoc """
  Implementation of the `Calendar.TimeZoneDatabase` behaviour.
  """

  alias TimeZoneInfo.{DataStore, NaiveDateTimeUtil}
  alias TimeZoneInfo.Transformer.Abbr

  @behaviour Calendar.TimeZoneDatabase

  @seconds_per_day 24 * 60 * 60
  @microseconds_per_second 1_000_000
  @parts_per_day @seconds_per_day * @microseconds_per_second

  def time_zone_periods_from_wall_datetime(naive_datetime, time_zone) do
    naive_datetime
    |> NaiveDateTimeUtil.to_gregorian_seconds()
    |> periods_from_wall_gregorian_seconds(time_zone, naive_datetime)
  end

  def time_zone_period_from_utc_iso_days(iso_days, time_zone) do
    iso_days
    |> iso_days_to_gregorian_seconds()
    |> period_from_utc_gregorian_seconds(time_zone, iso_days)
  end

  defp periods_from_wall_gregorian_seconds(at_wall_seconds, time_zone, at_wall_date_time) do
    case DataStore.get_transitions(time_zone) do
      {:ok, zone_states} ->
        zone_states
        |> find_zone_states(at_wall_seconds)
        |> to_periods(at_wall_seconds, at_wall_date_time)

      {:error, :transitions_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp period_from_utc_gregorian_seconds(gregorian_seconds, time_zone, date_time) do
    case DataStore.get_transitions(time_zone) do
      {:ok, transitions} ->
        transitions
        |> find_zone_state(gregorian_seconds)
        |> to_period(date_time)

      {:error, :transitions_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp find_zone_state(transitions, timestamp) do
    Enum.find_value(transitions, fn {at, zone_state} ->
      with true <- at <= timestamp, do: zone_state
    end)
  end

  defp find_zone_states(zone_states, at_wall) do
    Enum.reduce_while(zone_states, nil, fn
      zone_state_a, {:none, zone_state_b, zone_state_c} ->
        {:halt, {zone_state_a, zone_state_b, zone_state_c}}

      {at_utc, _} = zone_state, _ when at_utc > at_wall ->
        {:cont, zone_state}

      zone_state, nil ->
        {:cont, {:none, zone_state, :none}}

      zone_state, last_zone_state ->
        {:cont, {:none, zone_state, last_zone_state}}
    end)
  end

  defp to_period({_, _, {_, _}} = zone_state, {_, {_, _}} = iso_days) do
    to_period(zone_state, NaiveDateTimeUtil.from_iso_days(iso_days))
  end

  defp to_period({utc_offset, rule_name, {_, _} = format}, naive_datetime) do
    case DataStore.get_rules(rule_name) do
      {:ok, rules} ->
        rules
        |> transitions(utc_offset, naive_datetime.year)
        |> NaiveDateTimeUtil.sort(:desc)
        |> find_rule_data(naive_datetime)
        |> to_period(utc_offset, format)

      {:error, :rules_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp to_period({utc_offset, std_offset, zone_abbr}, _),
    do: {:ok, %{utc_offset: utc_offset, std_offset: std_offset, zone_abbr: zone_abbr}}

  defp to_period({std_offset, letters}, utc_offset, format) do
    {:ok,
     %{
       utc_offset: utc_offset,
       std_offset: std_offset,
       zone_abbr: Abbr.create(format, std_offset, letters)
     }}
  end

  defp to_periods({:none, {_at, {utc_offset, std_offset, zone_abbr}}, :none}, _, _) do
    {:ok, %{utc_offset: utc_offset, std_offset: std_offset, zone_abbr: zone_abbr}}
  end

  defp to_periods({:none, a, b}, at_wall, at_wall_datetime) do
    to_periods({a, b}, at_wall, at_wall_datetime)
  end

  defp to_periods({a, b, :none}, at_wall, at_wall_datetime) do
    to_periods({a, b}, at_wall, at_wall_datetime)
  end

  defp to_periods(
         {_zone_state_a, {_, {utc_offset, rule_name, format}}},
         at_wall,
         at_wall_datetime
       )
       when is_binary(rule_name) do
    calculate_periods(utc_offset, rule_name, format, at_wall, at_wall_datetime)
  end

  defp to_periods(
         {
           {_at_a, {utc_offset_a, std_offset_a, zone_abbr_a}},
           {at_b, {utc_offset_b, std_offset_b, zone_abbr_b}}
         },
         at_wall,
         _at_wall_datetime
       ) do
    at_wall_b = at_b + utc_offset_b + std_offset_b
    at_wall_ba = at_b + utc_offset_a + std_offset_a

    cond do
      at_wall_b <= at_wall && at_wall < at_wall_ba ->
        {
          :ambiguous,
          %{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a},
          %{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b}
        }

      at_wall_ba <= at_wall && at_wall < at_wall_b ->
        {
          :gap,
          {%{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_ba)},
          {%{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_b)}
        }

      at_wall < at_wall_b ->
        {:ok, %{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a}}

      true ->
        {:ok, %{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b}}
    end
  end

  defp to_periods(
         {_zone_state_a, _zone_state_b, {_, {utc_offset, rule_name, format}}},
         at_wall,
         at_wall_datetime
       )
       when is_binary(rule_name) do
    calculate_periods(utc_offset, rule_name, format, at_wall, at_wall_datetime)
  end

  defp to_periods(
         {
           {at_a, {utc_offset_a, std_offset_a, zone_abbr_a}},
           {at_b, {utc_offset_b, std_offset_b, zone_abbr_b}},
           {at_c, {utc_offset_c, std_offset_c, zone_abbr_c}}
         },
         at_wall,
         _at_wall_datetime
       ) do
    at_wall_a = at_a + utc_offset_a + std_offset_a
    at_wall_ba = at_b + utc_offset_a + std_offset_a
    at_wall_b = at_b + utc_offset_b + std_offset_b
    at_wall_cb = at_c + utc_offset_b + std_offset_b
    at_wall_c = at_c + utc_offset_c + std_offset_c

    cond do
      at_wall >= at_wall_c && at_wall < at_wall_cb ->
        {
          :ambiguous,
          %{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b},
          %{utc_offset: utc_offset_c, std_offset: std_offset_c, zone_abbr: zone_abbr_c}
        }

      at_wall >= at_wall_c ->
        {:ok, %{utc_offset: utc_offset_c, std_offset: std_offset_c, zone_abbr: zone_abbr_c}}

      at_wall >= at_wall_cb ->
        {
          :gap,
          {%{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_cb)},
          {%{utc_offset: utc_offset_c, std_offset: std_offset_c, zone_abbr: zone_abbr_c},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_c)}
        }

      at_wall >= at_wall_b && at_wall < at_wall_ba ->
        {
          :ambiguous,
          %{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a},
          %{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b}
        }

      at_wall >= at_wall_b ->
        {:ok, %{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b}}

      at_wall >= at_wall_ba ->
        {
          :gap,
          {%{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_ba)},
          {%{utc_offset: utc_offset_b, std_offset: std_offset_b, zone_abbr: zone_abbr_b},
           NaiveDateTimeUtil.from_gregorian_seconds(at_wall_b)}
        }

      at_wall >= at_wall_a ->
        {:ok, %{utc_offset: utc_offset_a, std_offset: std_offset_a, zone_abbr: zone_abbr_a}}
    end
  end

  defp calculate_periods(utc_offset, rule_name, format, at_wall_seconds, at_wall_datetime) do
    case DataStore.get_rules(rule_name) do
      {:ok, rules} ->
        rules
        |> transitions(utc_offset, at_wall_datetime.year - 1, at_wall_datetime.year + 1)
        |> NaiveDateTimeUtil.sort(:desc)
        |> Enum.map(fn {at, {std_offset, letters}} ->
          abbr = Abbr.create(format, std_offset, letters)
          at = NaiveDateTimeUtil.to_gregorian_seconds(at)
          {at, {utc_offset, std_offset, abbr}}
        end)
        |> find_zone_states(at_wall_seconds)
        |> to_periods(at_wall_seconds, at_wall_datetime)

      {:error, :rules_not_found} ->
        {:error, :time_zone_not_found}
    end
  end

  defp find_rule_data([{_, latest} | _] = transitions, naive_datetime) do
    Enum.find_value(transitions, latest, fn {timestamp_date_time, rule_data} ->
      with true <- NaiveDateTimeUtil.before_or_equal?(timestamp_date_time, naive_datetime),
           do: rule_data
    end)
  end

  defp transitions(rules, utc_offset, from, to) do
    from..to
    |> Enum.flat_map(fn year -> transitions(rules, utc_offset, year) end)
  end

  defp transitions(rules, utc_offset, year) do
    Enum.map(rules, fn {at, time_standard, std_offset, letters} ->
      date_time =
        year
        |> NaiveDateTimeUtil.from_iana(at)
        |> NaiveDateTimeUtil.to_utc(time_standard, utc_offset, std_offset)

      {date_time, {std_offset, letters}}
    end)
  end

  defp iso_days_to_gregorian_seconds({days, {parts_in_day, @parts_per_day}}) do
    div(days * @parts_per_day + parts_in_day, @microseconds_per_second)
  end
end
