defmodule TestPlug do
  use Plug.Builder

  plug(Plug.Static, at: "/", from: "test/fixtures")
  plug(:not_found)

  def not_found(conn, _), do: send_resp(conn, 404, "not found")
end
