defmodule Updater.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    run()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Updater.Supervisor]
    Supervisor.start_link([], opts)
  end

  defp run do
    {:ok, paris} = DateTime.from_naive(~N[2020-03-25 12:00:00], "Europe/Paris")
    Logger.info("Paris: #{inspect paris}")

    {:ok, ny} = DateTime.shift_zone(paris, "America/New_York")
    Logger.info("New York: #{inspect ny}")
  rescue
    _ -> :ok
  end
end
