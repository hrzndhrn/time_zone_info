defmodule TimeZoneInfoServer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    endpoint = [
      scheme: :http,
      plug: TimeZoneInfoServer.Endpoint,
      options: [port: 4001]
    ]

    children = [
      FakeUtcDateTime,
      {Plug.Cowboy, endpoint}
    ]

    opts = [strategy: :one_for_one, name: TimeZoneInfoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
