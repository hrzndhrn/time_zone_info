defmodule TimeZoneInfo.DataPersistence.Priv do
  @moduledoc """
  An implementation for the behaviour `TimeZoneInfo.DataPersistence` to persist
  data in the `priv` dir.
  """

  alias File.Stat
  alias TimeZoneInfo.ExternalTermFormat

  @behaviour TimeZoneInfo.DataPersistence

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
    with {:ok, path} <- fetch_env(:path) do
      path =
        :time_zone_info
        |> :code.priv_dir()
        |> Path.join(path)

      {:ok, path}
    end
  end

  defp fetch_env(:path) do
    with {:priv, {:ok, priv}} <- {:priv, Application.fetch_env(:time_zone_info, :priv)},
         {:path, {:ok, path}} when is_binary(path) <- {:path, Keyword.fetch(priv, :path)} do
      {:ok, path}
    else
      {:priv, :error} ->
        {:error, {:invalid_config, :priv}}

      {:path, :error} ->
        {:error, {:invalid_config, [:priv, :path]}}

      {:path, {:ok, path}} ->
        {:error, {:invalid_config, [priv: [path: path]]}}
    end
  end
end
