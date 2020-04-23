import Config

config :logger,
  level: :debug,
  console: [
    # changes the format for the log messages and hides the time
    format:
      IO.iodata_to_binary([
        IO.ANSI.color(252),
        "[$level] $message\n",
        IO.ANSI.default_color()
      ])
  ]

# sets the current time zone database
config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase

config :time_zone_info,
  # faske
  utc_datetime: FakeUtcDateTime,
  listener: TimeZoneInfo.Listener.Logger,
  lookahead: 1,
  files: ~w(europe asia),
  time_zones: [
    "Europe/Berlin",
    "Asia/Tokyo"
  ],
  update: :daily,
  downloader: [
    module: TimeZoneInfo.Downloader.Mint,
    uri: "http://localhost:4001/api/time_zone_info",
    mode: :ws
  ],
  # saves
  data_persistence: TimeZoneInfo.DataPersistence.FileSystem,
  file_system: [path: "data/tzi.etf"]
