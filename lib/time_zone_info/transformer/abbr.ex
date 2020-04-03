defmodule TimeZoneInfo.Transformer.Abbr do
  @moduledoc """
  This module provides some functions to create time zone abbreviations.
  """
  # TODO: check whether all functions are in use

  def create({:string, abbr}), do: abbr

  def create({:choice, [abbr, _]}), do: abbr

  def create({:string, abbr}, _), do: abbr

  def create({:template, abbr}, rule), do: String.replace(abbr, "%s", rule[:letters] || "")

  def create({:choice, [abbr_a, abbr_b]}, std_offset) when is_integer(std_offset)  do
    case std_offset do
      0 -> abbr_a
      _ -> abbr_b
    end
  end

  def create({:choice, _} = choice, rule), do: do_create(choice, rule[:std_offset])

  def create({:string, abbr}, _, _), do: abbr

  def create({:template, abbr}, _, letters), do: String.replace(abbr, "%s", letters || "")

  def create({:choice, _} = choice, std_offset, _), do: do_create(choice, std_offset)

  defp do_create({:choice, [a, b]}, std_offset) do
    case std_offset == 0 do
      true -> a
      false -> b
    end
  end
end
