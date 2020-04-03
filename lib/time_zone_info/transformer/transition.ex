defmodule TimeZoneInfo.Transformer.Transition do
  @moduledoc """
  This modules handles transitions during the transformation.
  """

  @type t :: {
          NaiveDateTime.t(),
          {
            Calendar.std_offset(),
            Calendar.utc_offset(),
            TimeZoneInfo.time_standard(),
            Calendar.zone_abbr()
          }
        }

  alias TimeZoneInfo.NaiveDateTimeUtil

  @doc """
  Returns the `std_offset` of a transition. If this function gets a list then
  the `std_offset` of the last transition will be returned.
  """
  @spec get_std_offset(transition | transitions) :: Calendar.std_offset()
        when transition: t(), transitions: [t()]
  def get_std_offset(transitions) when is_list(transitions) do
    transitions |> List.last() |> get_std_offset()
  end

  def get_std_offset({_since, {_utc_offset, std_offset, _time_standard, _abbr}}), do: std_offset

  @doc """
  Transforms transition date-times to UTC and creates the
  `TimeZoneInfo.time_zone_period`.
  """
  @spec transform([t()]) :: [{NaiveDateTime.t(), TimeZoneInfo.time_zone_period()}]
  def transform(transitions), do: transform(transitions, 0, [])

  defp transform([], _, acc), do: acc

  defp transform(
         [{since, {utc_offset, std_offset, time_standard, abbr}} | transitions],
         last_std_offset,
         acc
       ) do
    utc = NaiveDateTimeUtil.to_utc(since, time_standard, 0, last_std_offset)
    period = {utc_offset, std_offset, abbr}

    transform(transitions, std_offset, [{utc, period} | acc])
  end

  @doc """
  Adds a transition to transitions if the first transition does not have the
  same datetime or the same info.
  """
  @spec add_new(t(), [t()]) :: [t()]
  def add_new(transition, []), do: [transition]
  def add_new({at, _}, [{at, _} | _] = transitions), do: transitions

  def add_new({_, info}, [{_, info} | _] = transitions), do: transitions

  # def add_new(transition, transitions), do: [transition|transitions]

  # TODO: flip args
  # def add_new({at, _} = transition,
  # [{at_a, {_, std_offset_a, _, _}} | _] = transitions) do
  # case at == NaiveDateTime.add(at_a, std_offset_a * -1) do
  def add_new(transition, [head | rest] = transitions) do
    IO.inspect({transition, head}, label: :add_new)

    case add_new_check(transition, head) do
      true ->
        IO.inspect(true, label: :add_new)
        [do_add_new(transition, head) | transitions]

      false ->
        IO.inspect(false, label: :add_new)
        [transition|transitions]
    end
  end

  defp add_new_check(
    {at_a, {_, std_offset_a,_,_}},
    {at_b, {_, std_offset_b,_,_}}
  ) do
    at_a == NaiveDateTime.add(at_b, std_offset_a * -1)
  end

  defp do_add_new({at, _}, {_, info}), do: {at, info}


  def update(transitions, nil), do: transitions

  def update([{at, info} | tail], offset) do
    IO.inspect([at: at, offset: offset], label: :update)
    datetime = NaiveDateTime.add(at, offset * -1)
    [{datetime, info} | tail]
  end
end
