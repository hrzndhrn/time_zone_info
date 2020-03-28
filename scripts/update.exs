defmodule TimeZoneInfo.Scripts.Update do
  import Mix.Shell.IO, only: [info: 1, error: 1]

  alias TimeZoneInfo.{
    DataPersistence,
    Downloader,
    ExternalTermFormat,
    FileArchive,
    IanaParser,
    Transformer
  }

  def run do
    info("Update TimeZoneInfo Data")
    Logger.configure(level: :warn)
    Application.ensure_all_started(:time_zone_info)

    with {:ok, format, data} <- download(),
         {:ok, data} <- transform(format, data),
         :ok <- persist(data) do
      info("... ready!")
    else
      error -> error("Update failed! #{inspect(error)}")
    end
  end

  defp download do
    info("download: #{uri()} ...")
    Downloader.download()
  end

  defp transform(:iana, data) do
    with {:ok, {version, data}} <- extract(data, ["version" | files()]),
         {:ok, parsed} <- parse(data) do
      {:ok, transform(:data, parsed, version)}
    end
  end

  defp transform(:etf, data), do: ExternalTermFormat.decode(data)

  defp transform(:data, data, version) do
    info("transform ...")
    Transformer.transform(data, version)
  end

  defp parse(data) do
    info("parse ...")
    IanaParser.parse(data)
  end

  defp extract(data, files) do
    info("extract files ...")

    with {:ok, files} <- FileArchive.extract(data, files) do
      {version, files} = Map.pop(files, "version")
      {:ok, {String.trim(version), join(files)}}
    end
  end

  defp persist(data) do
    info("persist ...")
    DataPersistence.put(data)
  end

  defp join(files) do
    files |> Enum.map(fn {_name, content} -> content end) |> Enum.join("\n")
  end

  defp files, do: Application.get_env(:time_zone_info, :files)

  defp uri, do: Application.get_env(:time_zone_info, :downloader)[:uri]
end

TimeZoneInfo.Scripts.Update.run()
