import Config

config :logger,
  level: :debug,
  console: [
    # Changes the format for the log messages and hides the time.
    format:
      IO.iodata_to_binary([
        IO.ANSI.color(252),
        "[$level] $message\n",
        IO.ANSI.default_color()
      ])
  ]

# Sets the current time zone database.
config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase

config :time_zone_info,
  # Fakes the UTC date time to playing around with different date times.
  utc_datetime: FakeUtcDateTime,
  # Makes TimeZoneInfo a little bit chatty.
  listener: TimeZoneInfo.Listener.Logger,
  # TimeZoneInfo looks one year in the future.
  lookahead: 1,
  # The IANA files used to generate the data.
  files: ~w(europe asia),
  # Specifies which time zones are used.
  time_zones: [ "Europe/Berlin", "Asia/Tokyo" ],
  # Using the web service under the given URI.
  downloader: [
    module: TimeZoneInfo.Downloader.Mint,
    uri: "http://localhost:4001/api/time_zone_info",
    mode: :ws
  ],
  update: :daily,
  # Saves the data in the file system at the given path.
  data_persistence: TimeZoneInfo.DataPersistence.FileSystem,
  file_system: [path: "data/tzi.etf"]
