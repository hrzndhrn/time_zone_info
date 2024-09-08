defmodule TimeZoneInfo.IanaParser.Helper do
  @moduledoc false

  import NimbleParsec

  @seconds_per_hour 3600
  @seconds_per_minute 60

  @op %{
    ">=" => :ge,
    "<=" => :le
  }

  @default_time_standard :wall
  @time_standard %{
    "w" => @default_time_standard,
    "s" => :standard,
    "g" => :gmt,
    "u" => :utc,
    "z" => :zulu
  }

  @month %{
    "Jan" => 1,
    "January" => 1,
    "Feb" => 2,
    "February" => 2,
    "Mar" => 3,
    "March" => 3,
    "April" => 4,
    "Apr" => 4,
    "May" => 5,
    "Jun" => 6,
    "June" => 6,
    "Jul" => 7,
    "July" => 7,
    "Aug" => 8,
    "August" => 8,
    "Sep" => 9,
    "September" => 9,
    "Oct" => 10,
    "October" => 10,
    "Nov" => 11,
    "November" => 11,
    "Dec" => 12,
    "December" => 12
  }

  @day %{
    "Mon" => 1,
    "Monday" => 1,
    "Tue" => 2,
    "Tuesday" => 2,
    "Wed" => 3,
    "Wednesday" => 3,
    "Thu" => 4,
    "Thursday" => 4,
    "Fri" => 5,
    "Friday" => 5,
    "Sat" => 6,
    "Saturday" => 6,
    "Sun" => 7,
    "Sunday" => 7
  }

  def word(combinator \\ empty()) do
    concat(combinator, do_word())
  end

  def word(combinator, tag) do
    unwrap_and_tag(combinator, do_word(), tag)
  end

  defp do_word do
    [{:not, ?\t}, {:not, ?\n}, {:not, ?#}, {:not, ?\s}, {:not, ?\r}]
    |> utf8_char()
    |> repeat()
    |> reduce({:reduce_word, []})
  end

  def reduce_word(data) do
    case data |> IO.iodata_to_binary() |> String.trim() do
      "" -> nil
      "-" -> nil
      x -> x
    end
  end

  def choice_map(combinator \\ empty(), map) when is_map(map) do
    choice_map =
      map
      |> Map.keys()
      |> Enum.sort(:desc)
      |> Enum.map(&string/1)
      |> choice()
      |> reduce({:reduce_choice_map, [map]})

    concat(combinator, choice_map)
  end

  def reduce_choice_map([key], map), do: Map.fetch!(map, key)

  def choice_map_with_default(combinator \\ empty(), map, default) when is_map(map) do
    choice_map_with_default =
      map
      |> Map.keys()
      |> Enum.sort(:desc)
      |> Enum.map(&string/1)
      |> choice()
      |> optional()
      |> reduce({:reduce_choice_map_with_default, [map, default]})

    concat(combinator, choice_map_with_default)
  end

  def reduce_choice_map_with_default([], _map, default), do: default

  def reduce_choice_map_with_default([key], map, _default), do: Map.fetch!(map, key)

  def month(combinator \\ empty(), tag \\ nil) do
    month = choice_map(@month)

    if tag == nil do
      concat(combinator, month)
    else
      unwrap_and_tag(combinator, month, tag)
    end
  end

  def on(combinator \\ empty(), tag \\ nil) do
    day = integer(min: 1) |> unwrap_and_tag(:day)
    last_day = string("last") |> ignore() |> choice_map(@day) |> unwrap_and_tag(:last)
    day_from = choice_map(@day) |> choice_map(@op) |> integer(min: 1) |> tag(:day_from)

    on = choice([last_day, day, day_from]) |> reduce({:reduce_on, []})

    if tag == nil do
      concat(combinator, on)
    else
      unwrap_and_tag(combinator, on, tag)
    end
  end

  def reduce_on(day: day) do
    day
  end

  def reduce_on(last: day) do
    [last_day_of_week: day]
  end

  def reduce_on(day_from: [day_of_week, op, day]) do
    [day: day, op: op, day_of_week: day_of_week]
  end

  def until(combinator \\ empty()) do
    until =
      int()
      |> whitespace()
      |> optional(month())
      |> whitespace()
      |> optional(on())
      |> whitespace()
      |> optional(time())
      |> reduce({:reduce_until, []})

    unwrap_and_tag(combinator, until, :until)
  end

  def reduce_until(data) do
    case data do
      [yr, mo, dy, {hr, 0, 0}] -> {yr, mo, dy, hr}
      [yr, mo, dy, {hr, min, 0}] -> {yr, mo, dy, hr, min}
      [yr, mo, dy, {hr, min, sec}] -> {yr, mo, dy, hr, min, sec}
      list -> List.to_tuple(list)
    end
  end

  def time_standard(combinator \\ empty()) do
    unwrap_and_tag(
      combinator,
      choice_map_with_default(@time_standard, @default_time_standard),
      :time_standard
    )
  end

  def seconds do
    seconds(empty(), nil)
  end

  def seconds(combinator \\ empty(), tag) do
    next = ascii_char([?:]) |> optional() |> ignore() |> integer(min: 1)

    time =
      whitespace()
      |> optional(ascii_char([?-]))
      |> integer(min: 1)
      |> repeat(next)
      |> reduce({:reduce_seconds, []})

    if tag == nil do
      concat(combinator, time)
    else
      unwrap_and_tag(combinator, time, tag)
    end
  end

  def time(combinator \\ empty(), tag \\ nil) do
    next = ascii_char([?:]) |> optional() |> ignore() |> integer(min: 1)

    time =
      whitespace()
      |> optional(ascii_char([?-]))
      |> integer(min: 1)
      |> repeat(next)
      |> reduce({:reduce_time, []})

    if tag == nil do
      concat(combinator, time)
    else
      unwrap_and_tag(combinator, time, tag)
    end
  end

  def reduce_time(data) do
    case data do
      [hour] ->
        {hour, 0, 0}

      [hour, minute] ->
        {hour, minute, 0}

      [hour, minute, second] ->
        {hour, minute, second}
    end
  end

  def reduce_seconds([?- | data]) do
    to_seconds(data) * -1
  end

  def reduce_seconds(data) do
    to_seconds(data)
  end

  def to_seconds(data) do
    case data do
      [hour] ->
        hour * @seconds_per_hour

      [hour, minute] ->
        hour * @seconds_per_hour + minute * @seconds_per_minute

      [hour, minute, second] ->
        hour * @seconds_per_hour + minute * @seconds_per_minute + second
    end
  end

  def collect(combinator), do: reduce(combinator, {:reduce_collect, []})

  def reduce_collect(data) when is_list(data) do
    data
    |> Enum.group_by(
      fn {tag, _data} -> tag end,
      fn {_tag, data} -> data end
    )
    |> Enum.into(%{}, &reduce_collect/1)
  end

  def reduce_collect({:rule, data}) do
    rules =
      Enum.group_by(
        data,
        fn [{:name, name} | _] -> name end,
        fn [_ | data] -> data end
      )

    {:rules, rules}
  end

  def reduce_collect({:link, data}) do
    links = Enum.into(data, %{}, fn [to: to, from: from] -> {from, to} end)

    {:links, links}
  end

  def reduce_collect({:zone, data}) do
    zones =
      for [name: name, states: states] <- data, into: %{} do
        states =
          Enum.map(states, fn state ->
            case state[:until] do
              nil -> List.insert_at(state, 3, {:until, nil})
              _until -> state
            end
          end)

        {name, states}
      end

    {:zones, zones}
  end

  def rules(combinator) do
    rules = choice([seconds(), word()]) |> unwrap_and_tag(:rules)
    concat(combinator, rules)
  end

  def to_year(combinator) do
    only = string("only") |> replace(:only)
    max = string("max") |> replace(:max)

    unwrap_and_tag(combinator, choice([only, max, integer(min: 1)]), :to)
  end

  def unset(combinator \\ empty(), tag) do
    unset = [?-] |> utf8_char() |> replace(nil)

    unwrap_and_tag(combinator, unset, tag)
  end

  def int(combinator \\ empty(), tag \\ nil) do
    int = integer(min: 1)

    if tag == nil do
      concat(combinator, int)
    else
      unwrap_and_tag(combinator, int, tag)
    end
  end

  def close(combinator) do
    concat(
      combinator,
      [string("\n"), string("\r\n")] |> choice() |> optional() |> ignore()
    )
  end

  def close(combinator, tag) do
    combinator
    |> concat([string("\n"), string("\r\n")] |> choice() |> optional() |> ignore())
    |> reduce({:reduce_close, []})
    |> unwrap_and_tag(tag)
  end

  def reduce_close(data), do: data

  def whitespace(combinator \\ empty()) do
    whitespace = [?\s, ?\t] |> ascii_char() |> repeat() |> ignore()

    concat(combinator, whitespace)
  end

  def seperator(combinator \\ empty()) do
    seperator = [?\s, ?\t] |> ascii_char() |> times(min: 1) |> ignore()

    concat(combinator, seperator)
  end

  def text(combinator) do
    text = [{:not, ?\n}] |> utf8_char() |> repeat()

    concat(combinator, text)
  end

  def format(combinator) do
    format = reduce(word(), {:reduce_format, []})

    unwrap_and_tag(combinator, format, :format)
  end

  def reduce_format([format]) do
    cond do
      format == "%z" ->
        {:format, :z}

      String.contains?(format, "%s") ->
        {:template, format}

      String.contains?(format, "/") ->
        {:choice, String.split(format, "/")}

      true ->
        {:string, format}
    end
  end

  def zone_state(zone_state), do: zone_state

  def record(tag), do: ignore(string(tag) |> whitespace())
end
