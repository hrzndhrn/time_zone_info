defmodule TimeZoneInfo.Transformer.Abbr do
  @moduledoc """
  This module provides some functions to create time zone abbreviations.
  """

  @typedoc "The format of a `zone_abbr`."
  @type format ::
          {:string, String.t()}
          | {:template, String.t()}
          | {:choice, [String.t()]}

  @typedoc "The `letters` for the zone abbr format."
  @type letters :: String.t() | nil

  @doc """
  Creates the zone abbr.
  """
  @spec create(format(), Calendar.std_offset(), letters()) :: String.t()
  def create(format, std_offset \\ 0, letters \\ nil)

  def create({:string, abbr}, _std_offset, _letters), do: abbr

  def create({:choice, [abbr, _]}, 0, _letters), do: abbr

  def create({:choice, [_, abbr]}, _std_offset, _leters), do: abbr

  def create({:template, abbr}, _std_offset, letters),
    do: String.replace(abbr, "%s", letters || "")
end
