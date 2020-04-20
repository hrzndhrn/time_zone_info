import Config

config :logger, level: :debug

config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase

config :time_zone_info,
  utc_datetime: FakeUtcDateTime,
  listener: TimeZoneInfo.Listener.Logger,
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
  data_persistence: TimeZoneInfo.DataPersistence.FileSystem,
  file_system: [path: "data/tzi.etf"]
