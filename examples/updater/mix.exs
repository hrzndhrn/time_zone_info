defmodule Updater.MixProject do
  use Mix.Project

  def project do
    [
      app: :updater,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Updater.Application, []}
    ]
  end

  defp deps do
    [
      {:castore, "~> 0.1"},
      {:mint, "~> 1.0"},
      {:time_zone_info, "~> 0.6"}
      # {:time_zone_info, path: "../.."}
    ]
  end
end
