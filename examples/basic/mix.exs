defmodule Basic.MixProject do
  use Mix.Project

  def project do
    [
      app: :basic,
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
      mod: {Basic.Application, []}
    ]
  end

  defp deps do
    [
      {:time_zone_info, "~> 0.7"}
      # {:time_zone_info, path: "../.."}
    ]
  end
end
