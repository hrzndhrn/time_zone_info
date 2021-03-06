defmodule TimeZoneInfo.ExternalTermFormat do
  @moduledoc false

  # Encodes and decodes the `TimeZoneInfo.data`.

  @doc """
  Encodes `TimeZoneInfo.data` to binary.
  """
  @spec encode(TimeZoneInfo.data()) :: {:ok, binary()} | {:error, atom()}
  def encode(term) do
    with {:ok, term} <- validate(term) do
      binary = :erlang.term_to_binary(term, compressed: 9)
      {:ok, binary}
    end

    # rescue
    #  _ -> {:error, :encode_fails}
  end

  @doc """
  Decodes `TimeZoneInfo.data` from binary.
  """
  @spec decode(binary()) :: {:ok, TimeZoneInfo.data()} | {:error, atom()}
  def decode(binary) do
    binary |> :erlang.binary_to_term([:safe]) |> validate()
  rescue
    _error ->
      {:error, :decode_fails}
  end

  @doc """
  Returns a checksum for the `binary` or `TimeZoneInfo.data`.
  """
  @spec checksum(TimeZoneInfo.data()) :: {:ok, String.t()} | {:error, term()}
  def checksum(data) when is_map(data) do
    with {:ok, data} <- encode(data) do
      checksum(data)
    end
  end

  @spec checksum(binary) :: {:ok, String.t()} | {:error, term()}
  def checksum(data) when is_binary(data) do
    checksum = :md5 |> :crypto.hash(data) |> Base.encode16()
    {:ok, checksum}
  end

  # These functions validate the decoded data. The code ensures also that all
  # needed `atoms` are available that `:erlang.binary_to_term(binary, [:safe])`
  # raises not an error.
  # This could still be replaced by Xema.
  defp validate(term) when is_map(term) do
    with :ok <- validate(:keys, term),
         :ok <- validate(:links, term),
         :ok <- validate(:version, term),
         :ok <- validate(:config, term),
         :ok <- validate(:rules, term),
         :ok <- validate(:time_zones, term) do
      {:ok, term}
    end
  end

  defp validate(_term), do: {:error, :invalid_data}

  defp validate(:keys, term) do
    term
    |> Map.keys()
    |> Enum.sort()
    |> Kernel.==([:config, :links, :rules, :time_zones, :version])
    |> check(:invalid_keys)
  end

  defp validate(:version, term) do
    term
    |> Map.get(:version)
    |> is_binary()
    |> check(:invalid_version)
  end

  defp validate(:config, %{config: config}) do
    with :ok <- validate(:config_time_zones, config[:time_zones]),
         :ok <- validate(:config_lookahead, config[:lookahead]),
         :ok <- validate(:config_files, config[:files]) do
      :ok
    end
  end

  defp validate(:config_time_zones, :all), do: :ok

  defp validate(:config_time_zones, list) when is_list(list) do
    list
    |> Enum.all?(fn time_zone -> is_binary(time_zone) end)
    |> check({:invalid_config, [time_zones: list]})
  end

  defp validate(:config_time_zones, value), do: {:error, {:invalid_config, [time_zones: value]}}

  defp validate(:config_lookahead, lookahead) when is_integer(lookahead) and lookahead > 0,
    do: :ok

  defp validate(:config_lookahead, value), do: {:error, {:invalid_config, [lookahead: value]}}

  defp validate(:config_files, list) when is_list(list) do
    list
    |> Enum.all?(fn time_zone -> is_binary(time_zone) end)
    |> check({:invalid_config, [files: list]})
  end

  defp validate(:config_files, value), do: {:error, {:invalid_config, [files: value]}}

  defp validate(:links, term) do
    term
    |> Map.get(:links)
    |> Enum.all?(fn
      {from, to} when is_binary(from) and is_binary(to) -> true
      _ -> false
    end)
    |> check(:invalid_links)
  end

  defp validate(:time_zones, term) do
    term
    |> Map.get(:time_zones)
    |> Enum.all?(fn
      {name, zone_states} when is_binary(name) -> validate(:zone_states, zone_states)
      _ -> false
    end)
    |> check(:invalid_time_zones)
  end

  defp validate(:zone_states, zone_states) do
    Enum.all?(zone_states, fn
      {at, {utc_offset, std_offset, zone_abbr, wall_period}} when at >= 0 ->
        validate(:zone_state, {utc_offset, std_offset, zone_abbr, wall_period})

      {at, zone_rule} when at >= 0 ->
        validate(:zone_rule, zone_rule)

      _ ->
        false
    end)
  end

  defp validate(:zone_state, {utc_offset, std_offset, zone_abbr, {since, until}}) do
    zone_state = is_integer(utc_offset) && is_integer(std_offset) && is_binary(zone_abbr)
    since = since == :min || match?(%NaiveDateTime{}, since)
    until = until == :max || match?(%NaiveDateTime{}, until)

    zone_state && since && until
  end

  defp validate(:zone_rule, {utc_offset, rules, format})
       when is_integer(utc_offset) and is_binary(rules) and is_tuple(format) do
    validate(:format, format)
  end

  defp validate(:zone_state, _), do: false

  defp validate(:format, format) do
    case format do
      {:choice, [one, two]} when is_binary(one) and is_binary(two) -> true
      {:template, template} when is_binary(template) -> true
      {:string, string} when is_binary(string) -> true
      _ -> false
    end
  end

  # {{10, [last_day_of_week: 7], 1, 0, 0}, :utc, 0, nil},
  # {{3, [last_day_of_week: 7], 1, 0, 0}, :utc, 3600, "S"}
  defp validate(:rules, term) do
    term
    |> Map.get(:rules)
    |> Enum.all?(fn
      {name, rule_set} when is_binary(name) -> validate(:rule_set, rule_set)
      _ -> false
    end)
    |> check(:invalid_rules)
  end

  defp validate(:rule_set, rule_set) when is_list(rule_set) do
    Enum.all?(rule_set, fn rule -> validate(:rule, rule) end)
  end

  defp validate(:rule_set, _), do: false

  defp validate(:rule, {at, time_standard, utc_offset, letters})
       when is_tuple(at) and time_standard in [:wall, :standard, :gmt, :utc, :zulu] and
              is_integer(utc_offset) and (is_binary(letters) or is_nil(letters)) do
    validate(:at, at)
  end

  defp validate(:rule, _), do: false

  defp validate(:at, {month, day, {hour, minute, second}})
       when is_integer(month) and is_integer(hour) and is_integer(minute) and is_integer(second) do
    validate(:day, day)
  end

  defp validate(:at, _), do: false

  defp validate(:day, day) when is_integer(day), do: true

  defp validate(:day, day) when is_list(day) do
    case day do
      [last_day_of_week: day] when is_integer(day) ->
        true

      [day: day, op: op, day_of_week: day_of_week]
      when is_integer(day) and op in [:le, :ge] and is_integer(day_of_week) ->
        true

      _ ->
        false
    end
  end

  defp validate(:day, _), do: false

  defp check(true, _), do: :ok

  defp check(false, error), do: {:error, error}
end
