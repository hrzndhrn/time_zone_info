defmodule TimeZoneInfo do
  @moduledoc """
  `TimeZoneInfo` provides a time zone database for
  [Elixir](https://elixir-lang.org/) using the data from the
  [the Internet Assigned Numbers Authority (IANA)](https://www.iana.org/time-zones).

  Therefore `TimeZoneInfo` contains an implementation of the
  `Calendar.TimeZoneDatabase` behaviour under `TimeZoneInfo.TimeZoneDatabase`.
  """

  alias TimeZoneInfo.{
    DataConfig,
    DataPersistence,
    DataStore,
    ExternalTermFormat,
    FileArchive,
    IanaParser,
    Transformer,
    Transformer.Abbr,
    Worker
  }

  @default_lookahead 15
  @default_files ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

  @typedoc "Seconds since year 0 in the gregorian calendar."
  @type gregorian_seconds :: integer()

  @typedoc "The data structure containing all informations for `TimeZoneInfo`."
  @type data :: %{
          required(:version) => String.t(),
          required(:time_zones) => %{Calendar.time_zone() => [transition()]},
          required(:rules) => %{TimeZoneInfo.rule_name() => [rule()]},
          required(:links) => %{Calendar.time_zone() => Calendar.time_zone()}
        }

  @typedoc "The name of a rule set that can be found in the IANA data."
  @type rule_name :: String.t()

  @typedoc """
  A transition marks a point in time when one or more of the values `utc-offset`,
  `std_offset` or `zone-abbr` change.
  """
  @type transition :: {gregorian_seconds() | NaiveDateTime.t(), zone_state}

  @typedoc "The `zone_state` is either a `timezone_period` or a `rules_ref`."
  @type zone_state :: time_zone_period | rules_ref

  @typedoc """
  A reference to a rule set. The reference also contains `utc_offset` and
  `format`,
  The reference contains `utc_offset` and `format` because these values are needed
  to apply a `rule`.
  """
  @type rules_ref :: {Calendar.utc_offset(), rule_name(), Abbr.format()}

  @typedoc """
  The wall time period represented in a tuple with two naive date times.
  """
  @type wall_period :: {NaiveDateTime.t(), NaiveDateTime.t()}

  @typedoc """
  A period where a certain combination of UTC offset, standard offset and zone
  abbreviation is in effect. The `wall_period` contains the start and end of the
  time zone period in wall time.
  """
  @type time_zone_period :: {
          Calendar.utc_offset(),
          Calendar.std_offset(),
          Calendar.zone_abbr(),
          wall_period
        }

  @typedoc "A rule representation."
  @type rule :: {
          {
            Calendar.month(),
            IanaParser.day(),
            {Calendar.hour(), Calendar.minute(), Calendar.second()}
          },
          time_standard,
          Calendar.std_offset(),
          Abbr.letters()
        }

  @typedoc "The time standards used by IANA."
  @type time_standard :: :wall | :standard | :gmt | :utc | :zulu

  @typedoc "The configuration for data generation"
  @type config :: [
          files: [String.t()],
          time_zones: [Calendar.time_zone()],
          lookahead: non_neg_integer()
        ]

  @doc """
  Returns the list of all available time zones with or without links. The option
  `:links` can be used to customize the list.

  Values for `:links`:
  - `:ignore` just the time zone names will be returned
  - `:only` just the link names will be returned
  - `:include` the time zone and link names will be returned (default)

  The list will be sorted.
  """
  @spec time_zones(links: :ignore | :only | :include) :: [Calendar.time_zone()]
  def time_zones(opts \\ [links: :include]), do: DataStore.get_time_zones(opts)

  @doc """
  Returns the version of the IANA database.
  """
  @spec iana_version :: String.t()
  def iana_version, do: DataStore.version()

  @doc """
  Triggers the update process. Withe the `opt` `:force` the update will be
  forced.
  """
  @spec update(opt :: :run | :force) :: :ok | {:next, non_neg_integer()} | {:error, term()}
  def update(opt \\ :run) when opt in [:run, :force], do: Worker.update(opt)

  @doc """
  Returns the date time in UTC for the next update. Retruns `:never` if the
  automated update disabled.
  """
  @spec next_update :: DateTime.t() | :never | :error
  def next_update do
    case Worker.next() do
      {:next, value} -> value
      _ -> :error
    end
  end

  @doc """
  Returns the state of `TimeZoneInfo`.

  Returns
  - `:ok` if everything runs normal and the automated update is disabled.
  - `{:next, seconds}` if everything runs normal.
  - `{:error, reason}` in case of an error.
  """
  @spec state :: :ok | {:next, non_neg_integer()} | {:error, term()}
  def state, do: Worker.state()

  @doc """
  Returns infos about persisted and stored data.
  """
  def info do
    %{
      store: DataStore.info(),
      persistence: DataPersistence.info(),
      worker: Worker.state()
    }
  end

  @doc """
  Generates `TimeZoneInfo.data` from the given `iana_data_archive`.
  """
  @spec data(binary(), config()) :: {:ok, binary() | data(), String.t()} | {:error, term()}
  def data(iana_data_archive, config \\ []) do
    with {:ok, config} <- validate(config),
         {:ok, files} <- FileArchive.extract(iana_data_archive, config[:files]),
         {:ok, version, content} <- content(files),
         {:ok, parsed} <- IanaParser.parse(content),
         data <- Transformer.transform(parsed, version, config),
         {:ok, data} <- DataConfig.update(data, config),
         {:ok, checksum} <- ExternalTermFormat.checksum(data),
         {:ok, data} <- encode(data, config[:encode]) do
      {:ok, data, checksum}
    end
  end

  defp encode(data, true), do: ExternalTermFormat.encode(data)

  defp encode(data, _), do: {:ok, data}

  defp content(files) do
    case Map.pop(files, "version") do
      {nil, _} -> {:error, :version_not_found}
      {version, files} -> {:ok, String.trim(version), join(files)}
    end
  end

  defp join(files) do
    files |> Enum.map(fn {_name, content} -> content end) |> Enum.join("\n")
  end

  defp validate(config) do
    with {:ok, config} <- validate(:lookahead, config),
         {:ok, config} <- validate(:files, config),
         {:ok, config} <- validate(:version, config) do
      {:ok, config}
    end
  end

  defp validate(:version, config) do
    files = config[:files]

    case Enum.member?(files, "version") do
      true -> {:ok, config}
      false -> {:ok, Keyword.put(config, :files, ["version" | files])}
    end
  end

  defp validate(:files, config) do
    case config[:files] do
      nil -> {:ok, Keyword.put(config, :files, @default_files)}
      files when is_list(files) -> {:ok, config}
      value -> {:error, {:invalid_config, [files: value]}}
    end
  end

  defp validate(:lookahead, config) do
    case config[:lookahead] do
      nil -> {:ok, Keyword.put(config, :lookahead, @default_lookahead)}
      years when is_integer(years) -> {:ok, config}
      value -> {:error, {:invalid_config, [lookahead: value]}}
    end
  end
end
