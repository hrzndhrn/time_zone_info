defmodule TimeZoneInfo.Updater do
  @moduledoc false

  # Handles the automatic update and the initial setup.

  @behaviour TimeZoneInfo.Updater.Interface

  require Logger

  alias TimeZoneInfo.{
    DataConfig,
    DataPersistence,
    DataStore,
    Downloader,
    ExternalTermFormat,
    FileArchive,
    IanaParser,
    Listener,
    Transformer,
    UtcDateTime
  }

  @type step ::
          :run
          | :initial
          | :force
          | :check
          | :disabled
          | :finally
          | :maybe

  @seconds_per_day 24 * 60 * 60
  @default_lookahead 5

  @doc """
  Updates the TimeZoneInfo data.

  With `opt` `:run` an normal update process is started. The `opt` `:force`
  forced an update process.

  Returns
  - `:ok` if automatic updates are disabled.
  - `{:next, seconds}` where `seconds` is the time to wait until the next update.
  - `{:error, reason}` in case of an error.
  """
  @spec update(opt :: :run | :force) :: :ok | {:next, Calendar.second()} | {:error, term()}
  def update(step \\ :run) do
    with {:error, _} = error <- step |> step() |> do_update() do
      Listener.on_update(error)
      error
    end
  end

  defp do_update(:initial) do
    Listener.on_update(:initial)

    with {:ok, data} <- DataPersistence.fetch(),
         {:ok, time_zones} <- fetch_env(:time_zones),
         {:ok, data} <- DataConfig.update(data, time_zones: time_zones),
         :ok <- DataStore.put(data) do
      do_update(:check)
    else
      {:error, {:time_zones_not_found, _}} = error ->
        force_update(error)

      {:error, :enoent} = error ->
        force_update(error)

      error ->
        error
    end
  end

  defp do_update(:force), do: force_update(:ok)

  defp do_update(:check) do
    Listener.on_update(:check)

    with {:ok, interval} <- fetch_env(:update), do: do_update(interval)
  end

  defp do_update(:disabled), do: :ok

  defp do_update(:daily) do
    with {:ok, last_update} <- DataPersistence.fetch_last_update() do
      now = UtcDateTime.now(:unix)

      case last_update + @seconds_per_day - now do
        next when next > 0 ->
          {:next, now + next}

        _next ->
          with :ok <- do_update(:maybe),
               :ok <- DataPersistence.put_last_update(now) do
            {:next, now + @seconds_per_day}
          end
      end
    end
  end

  defp do_update(:maybe) do
    with {:ok, checksum_persistence} <- DataPersistence.checksum(),
         {:ok, data} when not is_atom(data) <- download(),
         {:ok, checksum_download} <- ExternalTermFormat.checksum(data) do
      case checksum_persistence == checksum_download do
        true ->
          Listener.on_update(:up_to_date)
          :ok

        false ->
          do_update(:finally, data)
      end
    else
      {:ok, :not_modified} ->
        Listener.on_update(:up_to_date)
        :ok

      error ->
        error
    end
  end

  defp do_update(:finally, data) do
    Listener.on_update(:update)

    with {:ok, time_zones} <- fetch_env(:time_zones),
         {:ok, data} <- DataConfig.update(data, time_zones: time_zones),
         :ok <- DataStore.put(data),
         :ok <- DataPersistence.put(data) do
      :ok
    end
  end

  defp force_update(on_disabled) do
    Listener.on_update(:force)

    now = UtcDateTime.now(:unix)

    with {:ok, update} when update != :disabled <- fetch_env(:update),
         {:ok, data} when not is_atom(data) <- download(),
         :ok <- do_update(:finally, data),
         :ok <- DataPersistence.put_last_update(now) do
      {:next, now + @seconds_per_day}
    else
      {:ok, :not_modified} ->
        Listener.on_update(:up_to_date)
        {:next, now + @seconds_per_day}

      {:ok, :disabled} ->
        on_disabled

      error ->
        error
    end
  end

  defp download do
    Listener.on_update(:download)

    with {:ok, files} <- files(),
         {:ok, time_zones} <- fetch_env(:time_zones),
         {:ok, lookahead} <- fetch_env(:lookahead) do
      opts = [files: files, time_zones: time_zones, lookahead: lookahead]

      opts =
        case DataPersistence.checksum() do
          {:ok, checksum} -> Keyword.put(opts, :checksum, checksum)
          _ -> opts
        end

      case Downloader.download(opts) do
        {:ok, :iana, {200, data}} ->
          transform(data)

        {:ok, mode, {200, data}} when mode in [:etf, :ws] ->
          ExternalTermFormat.decode(data)

        {:ok, _mode, {304, _body}} ->
          {:ok, :not_modified}

        {:ok, _mode, response} ->
          {:error, response}

        error ->
          error
      end
    end
  end

  defp transform(data) do
    with {:ok, version, content} <- extract(data),
         {:ok, parsed} <- IanaParser.parse(content),
         {:ok, time_zones} <- fetch_env(:time_zones),
         {:ok, lookahead} <- fetch_env(:lookahead) do
      {:ok, Transformer.transform(parsed, version, lookahead: lookahead, time_zones: time_zones)}
    end
  end

  defp extract(data) do
    with {:ok, files} <- files(),
         {:ok, contents} <- FileArchive.extract(data, files) do
      {version, contents} = Map.pop(contents, "version")
      {:ok, String.trim(version), join(contents)}
    end
  end

  defp join(files) do
    files |> Enum.map(fn {_name, content} -> content end) |> Enum.join("\n")
  end

  defp step(:run) do
    case DataStore.empty?() do
      true -> :initial
      false -> :check
    end
  end

  defp step(step), do: step

  defp files do
    with {:ok, files} <- fetch_env(:files) do
      {:ok, ["version" | files]}
    end
  end

  defp fetch_env(:files) do
    with :error <- Application.fetch_env(:time_zone_info, :files) do
      {:error, {:invalid_config, :files}}
    end
  end

  defp fetch_env(:update) do
    case Application.fetch_env(:time_zone_info, :update) do
      {:ok, value} when value in [:disabled, :daily] ->
        {:ok, value}

      {:ok, value} ->
        {:error, {:invalid_config, [update: value]}}

      :error ->
        {:error, {:invalid_config, :update}}
    end
  end

  defp fetch_env(:lookahead) do
    case Application.get_env(:time_zone_info, :lookahead, @default_lookahead) do
      value when value > 0 ->
        {:ok, value}

      value ->
        {:error, {:invalid_config, [lookahead: value]}}
    end
  end

  defp fetch_env(:time_zones) do
    value = Application.get_env(:time_zone_info, :time_zones, [])
    valid = is_list(value) && Enum.all?(value, &is_binary/1)

    case {valid, value} do
      {true, []} -> {:ok, :all}
      {true, time_zones} -> {:ok, time_zones}
      _ -> {:error, {:invalid_config, [time_zones: value]}}
    end
  end
end
