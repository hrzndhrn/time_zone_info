defmodule TimeZoneInfo.Updater do
  @moduledoc """
  Handles the automatic update and the initial setup.
  """

  @behaviour TimeZoneInfo.Updater.Interface

  require Logger

  alias TimeZoneInfo.{
    DataPersistence,
    DataStore,
    Downloader,
    ExternalTermFormat,
    FileArchive,
    IanaParser,
    Listener,
    Transformer
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
  def update(opt \\ :run) do
    step = with :run <- opt, do: mode()
    do_update(step)
  end

  defp do_update(:initial) do
    Listener.on_update(:initial)

    with {:ok, data} <- DataPersistence.fetch(),
         :ok <- DataStore.put(data) do
      do_update(:check)
    else
      {:error, :enoent} -> do_update(:force)
      error -> error
    end
  end

  defp do_update(:check) do
    Listener.on_update(:check)

    with {:ok, interval} <- fetch_env(:update), do: do_update(interval)
  end

  defp do_update(:disabled), do: :ok

  defp do_update(:daily) do
    with {:ok, last_update} <- DataPersistence.fetch_last_update() do
      now = DateTime.utc_now() |> DateTime.to_unix()

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
         {:ok, data} <- download(),
         {:ok, checksum_download} <- ExternalTermFormat.checksum(data) do
      case checksum_persistence == checksum_download do
        true ->
          Listener.on_update(:up_to_date)
          :ok

        false ->
          do_update(:finally, data)
      end
    end
  end

  defp do_update(:force) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    with {:ok, mode} when mode != :disabled <- fetch_env(:update),
         {:ok, data} <- download(),
         :ok <- do_update(:finally, data),
         :ok <- DataPersistence.put_last_update(now) do
      {:next, now + @seconds_per_day}
    else
      _ -> :ok
    end
  end

  defp do_update(:finally, data) do
    Listener.on_update(:update)

    with :ok <- DataStore.put(data),
         :ok <- DataPersistence.put(data) do
      :ok
    end
  end

  defp download do
    Listener.on_update(:download)

    with {:ok, format, data} <- Downloader.download() do
      case format do
        :iana -> transform(data)
        :etf -> ExternalTermFormat.decode(data)
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

  defp mode do
    case DataStore.empty?() do
      true -> :initial
      false -> :check
    end
  end

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
