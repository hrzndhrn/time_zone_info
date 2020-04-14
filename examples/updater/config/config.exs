import Config

config :elixir, :time_zone_database, TimeZoneInfo.TimeZoneDatabase

config :time_zone_info, [
  time_zones: ["ff"],
  listener: TimeZoneInfo.Listener.Logger,
  update: :daily
]

config :logger, level: :info
