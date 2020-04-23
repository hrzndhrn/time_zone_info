defmodule TimeZoneInfoServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    endpoint = [
      scheme: :http,
      plug: TimeZoneInfoServer.Endpoint,
      options: [port: 4001]
    ]

    children = [
      # Starts a worker by calling: TimeZoneInfoServer.Worker.start_link(arg)
      # {TimeZoneInfoServer.Worker, arg}
      FakeUtcDateTime,
      {Plug.Cowboy, endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeZoneInfoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
