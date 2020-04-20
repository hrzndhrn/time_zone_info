defmodule TimeZoneInfoServer.Controller do
  @moduledoc false

  require Logger

  import Plug.Conn

  @iana_data "2019c.tar.gz"
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
          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(304, "Not Modified")

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

  defp modified?(conn, checksum), do: get_req_header(conn, "if-none-match") != [checksum]

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
    |> Path.join(@iana_data)
    |> File.read()
  end
end
