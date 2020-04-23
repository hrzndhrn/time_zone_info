defmodule TimeZoneInfoServer.Endpoint do
  @moduledoc false

  use Plug.Router

  alias TimeZoneInfoServer.Controller

  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/api/time_zone_info" do
    Controller.get(conn)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
