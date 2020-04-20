defmodule TimeZoneInfo.MixProject do
  use Mix.Project

  def project do
    [
      app: :time_zone_info,
      version: "0.3.0",
      elixir: "~> 1.8",
      name: "TimeZoneInfo",
      description: description(),
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      dialyzer: dialyzer(),
      source_url: "https://github.com/hrzndhrn/time_zone_info",
      docs: docs(),
      package: package()
    ]
  end

  def description do
    "Time zone support for Elixir by using the IANA Time Zone Database."
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TimeZoneInfo.Application, []},
      env: env()
    ]
  end

  defp env do
    [
      files: ~w(africa antarctica asia australasia etcetera europe northamerica southamerica),
      lookahead: 15,
      data_store: :detect,
      update: :disabled,
      listener: TimeZoneInfo.Listener.ErrorLogger,
      downloader: [
        module: TimeZoneInfo.Downloader.Mint,
        uri: "https://data.iana.org/time-zones/tzdata-latest.tar.gz",
        mode: :iana,
        headers: [
          {"content-type", "application/gzip"},
          {"user-agent", "Elixir.TimeZoneInfo.Mint"}
        ]
      ],
      data_persistence: TimeZoneInfo.DataPersistence.Priv,
      priv: [path: "data.etf"]
    ]
  end

  defp preferred_cli_env do
    [
      carp: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.travis": :test
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "docs/config.md"
      ],
      groups_for_modules: [
        Behaviours: [
          TimeZoneInfo.DataPersistence,
          TimeZoneInfo.Downloader,
          TimeZoneInfo.Listener
        ],
        DataPersistence: [
          TimeZoneInfo.DataPersistence.Priv,
          TimeZoneInfo.DataPersistence.FileSystem
        ],
        Downlaoder: [
          TimeZoneInfo.Downloader.Mint
        ],
        Listener: [
          TimeZoneInfo.Listener.ErrorLogger,
          TimeZoneInfo.Listener.Logger
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:mint, :nimble_parsec],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      flags: [:unmatched_returns]
    ]
  end

  defp aliases do
    [
      bench: ["run bench/run.exs"],
      "bench.gen.data": ["run bench/scripts/gen_data.exs"],
      "tzi.update": ["run scripts/update.exs"],
      test: ["test --no-start"],
      carp: ["test --no-start --max-failures 1"]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_markdown, "~> 0.1", only: :dev},
      {:castore, "~> 0.1", optional: true},
      {:credo, "~> 1.4.0-rc.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:hackney, "~> 1.15", only: [:test, :dev], runtime: false},
      {:mint, "~> 1.0", optional: true},
      {:mox, "~> 0.5", only: :test},
      {:nimble_parsec, "~> 0.5", runtime: false},
      {:plug_cowboy, "~> 2.0", only: [:dev, :test]},
      {:stream_data, "~> 0.4", only: [:dev, :test], runtime: false},
      {:tz, "~> 0.8", only: [:test, :dev], runtime: false},
      {:tzdata, "~> 1.0", only: [:test, :dev], runtime: true}
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hrzndhrn/time_zone_info"},
      files: [
        "lib",
        "priv",
        "mix.exs",
        "README*",
        "LICENSE*",
        "docs/config.md"
      ]
    ]
  end
end
