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
  same datetime.
  """
  @spec add_new(t(), [t()]) :: [t()]
  def add_new({at, _}, [{at, _} | _] = transitions), do: transitions

  def add_new({at, _} = transition, [{at_a, {_, std_offset_a, _, _}} | _] = transitions) do
    case at == NaiveDateTime.add(at_a, std_offset_a * -1) do
      true -> transitions
      false -> [transition | transitions]
    end
  end

  def add_new(transition, transitions), do: [transition | transitions]
end
