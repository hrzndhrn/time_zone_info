defmodule TimeZoneInfoServer.Controller do
  @moduledoc false

  require Logger

  import Plug.Conn

  @iana_tzdata "tzdata2020a.tar.gz"
  @default_lookahead 15
  @default_files ~w(
    version africa antarctica asia australasia etcetera europe northamerica southamerica
  )

  def get(conn) do
    config = config(conn)
    Logger.debug("config: #{inspect config}")

    with {:ok, file} <- iana_data(),
         {:ok, data, checksum} <- TimeZoneInfo.data(file, config) do
      case modified?(conn, checksum) do
        false ->
          Logger.debug("Not modified.")
          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(304, "")

        true ->
          conn
          |> put_resp_content_type("application/gzip")
          |> send_resp(200, data)
      end
    else
      error ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(500, inspect(error))
    end
  end

  defp modified?(conn, checksum) do
    if_none_match = get_req_header(conn, "if-none-match")
    Logger.debug("header: if-none-match: #{inspect if_none_match}")
    Logger.debug("checksum: #{checksum}")
    if_none_match != [checksum]
  end

  defp config(conn) do
    conn
    |> fetch_query_params()
    |> Map.get(:query_params)
    |> Enum.reduce([], fn
      {"time_zones", time_zones}, acc -> [{:time_zones, time_zones} | acc]
      {"files", files}, acc -> [{:files, files} | acc]
      {"lookahead", lookahead}, acc -> [{:lookahead, lookahead} | acc]
      _, acc -> acc
    end)
    |> Keyword.update(:lookahead, @default_lookahead, fn lookahead ->
      case Integer.parse(lookahead) do
        {years, ""} -> years
        _ -> lookahead
      end
    end)
    |> Keyword.put_new(:files, @default_files)
    |> Keyword.put(:encode, true)
  end

  defp iana_data do
    :time_zone_info_server
    |> Application.get_env(:iana_data_path)
    |> Path.join(@iana_tzdata)
    |> File.read()
  end
end
