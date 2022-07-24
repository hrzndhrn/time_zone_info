defmodule Clock.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Clock,
      FakeUtcDateTime
    ]

    opts = [strategy: :one_for_one, name: Clock.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
