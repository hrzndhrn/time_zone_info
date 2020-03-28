defmodule TimeZoneInfo.Transformer.Abbr do
  @moduledoc false

  def create({:string, abbr}), do: abbr

  def create({:choice, [abbr, _]}), do: abbr

  def create({:string, abbr}, _), do: abbr

  def create({:template, abbr}, rule), do: String.replace(abbr, "%s", rule[:letters] || "")

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
