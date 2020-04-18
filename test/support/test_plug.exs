defmodule TestPlug do
  use Plug.Builder

  defmodule Controller.TimeZoneInfo do
    import Plug.Conn

    @iana_data_archive "test/fixtures/iana/2019c.tar.gz"

    def get(conn) do
      config = config(conn)

      with {:ok, file} <- File.read(@iana_data_archive),
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
      |> Keyword.update(:lookahead, nil, fn lookahead ->
        case Integer.parse(lookahead) do
          {years, ""} -> years
          _ -> lookahead
        end
      end)
      |> Keyword.put(:encode, true)
    end
  end

  defmodule Router do
    use Plug.Router

    alias Controller.TimeZoneInfo

    plug Plug.Static, at: "/fixtures", from: "test/fixtures"
    plug :match
    plug :dispatch

    get "/api/time_zone_info" do
      TimeZoneInfo.get(conn)
    end

    match _ do
      send_resp(conn, 404, "Not Found")
    end
  end

  plug Router
end
