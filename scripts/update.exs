defmodule TimeZoneInfo.Scripts.Update do
  import Mix.Shell.IO, only: [info: 1, error: 1]

  alias TimeZoneInfo.{
    Downloader,
    ExternalTermFormat,
    FileArchive,
    IanaParser,
    Transformer
  }

  @path "priv/data.etf"

  def run([file]) do
    do_run(:iana, File.read!(file))
  end

  def run([]) do
    uri = uri()
    info("Download: #{uri}")

    opts = [
      uri: uri,
      mode: :iana,
      headers: headers()
    ]

    with {:ok, format, {200, data}} <- Downloader.download(opts) do
      do_run(format, data)
    else
      error -> error("Update failed! #{inspect(error)}")
    end
  end

  def do_run(format, data) do
    with {:ok, data} <- transform(format, data),
         {:ok, checksum} <- ExternalTermFormat.checksum(data),
         {:ok, compressed} <- ExternalTermFormat.encode(data) do
      info("Checksum: #{checksum}")
      info("Write: #{@path}")
      File.write!(@path, compressed)
    else
      error -> error("Update failed! #{inspect(error)}")
    end
  end

  defp transform(:iana, data) do
    with {:ok, {version, data}} <- extract(data, ["version" | files()]),
         {:ok, parsed} <- IanaParser.parse(data) do
      {:ok, transform(:data, parsed, version)}
    end
  end

  defp transform(:etf, data), do: ExternalTermFormat.decode(data)

  defp transform(:data, data, version) do
    info("Version: #{version}")
    Transformer.transform(data, version)
  end

  defp extract(data, files) do
    with {:ok, files} <- FileArchive.extract(data, files) do
      {version, files} = Map.pop(files, "version")
      {:ok, {String.trim(version), join(files)}}
    end
  end

  defp join(files) do
    files |> Enum.map(fn {_name, content} -> content end) |> Enum.join("\n")
  end

  defp files, do: Application.get_env(:time_zone_info, :files)

  defp uri, do: Application.get_env(:time_zone_info, :downloader)[:uri]

  defp headers, do: Application.get_env(:time_zone_info, :downloader)[:headers]
end

Mix.Shell.IO.info("Update TimeZoneInfo Data")
Logger.configure(level: :warn)
TimeZoneInfo.Scripts.Update.run(System.argv())
