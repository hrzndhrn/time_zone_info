defmodule TimeZoneInfoServer.ControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn.Query
  alias TimeZoneInfoServer.Endpoint

  @opts Endpoint.init([])

  test "returns data" do
    query =Query.encode(%{files: ~w(version europe)})
    conn = conn(:get, "/api/time_zone_info?#{query}")

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end
end
