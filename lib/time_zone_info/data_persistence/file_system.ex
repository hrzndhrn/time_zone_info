defmodule TimeZoneInfo.DataPersistence.FileSystem do
  @moduledoc """
  An implementation for the behaviour `TimeZoneInfo.DataPersistence` to persist
  data in the file system.
  """

  @behaviour TimeZoneInfo.DataPersistence

  alias File.Stat
  alias TimeZoneInfo.ExternalTermFormat

  @impl true
  def put(data) do
    with {:ok, path} <- fetch_path(),
         {:ok, data} <- ExternalTermFormat.encode(data) do
      File.write(path, data)
    end
  end

  @impl true
  def fetch do
    with {:ok, path} <- fetch_path(),
         {:ok, data} <- File.read(path) do
      ExternalTermFormat.decode(data)
    end
  end

  @impl true
  def checksum do
    with {:ok, path} <- fetch_path(),
         {:ok, data} <- File.read(path) do
      ExternalTermFormat.checksum(data)
    end
  end

  @impl true
  def fetch_last_update do
    with {:ok, path} <- fetch_path(),
         {:ok, %Stat{mtime: mtime}} <- File.stat(path, time: :posix) do
      {:ok, mtime}
    end
  end

  @impl true
  def put_last_update(time) do
    with {:ok, path} <- fetch_path() do
      case File.exists?(path) do
        true -> File.touch(path, time)
        false -> {:error, :enoent}
      end
    end
  end

  @impl true
  def info do
    with {:ok, path} <- fetch_path(),
         {:ok, stat} <- File.stat(path),
         {:ok, data} <- File.read(path) do
      %{
        stat: stat,
        path: path,
        checksum: ExternalTermFormat.checksum(data)
      }
    end
  end

  @spec fetch_path ::
          {:ok, Path.t()} | {:error, {:invalid_config, Keyword.key() | [Keyword.key()]}}
  defp fetch_path do
    with {:file_system, {:ok, file_system}} <-
           {:file_system, Application.fetch_env(:time_zone_info, :file_system)},
         {:path, {:ok, path}} when is_binary(path) <-
           {:path, Keyword.fetch(file_system, :path)} do
      {:ok, path}
    else
      {:file_system, :error} ->
        {:error, {:invalid_config, :file_system}}

      {:path, :error} ->
        {:error, {:invalid_config, [:file_system, :path]}}

      {:path, {:ok, path}} ->
        {:error, {:invalid_config, [file_system: [path: path]]}}
    end
  end
end
