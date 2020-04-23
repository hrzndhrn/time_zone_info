import Config

config :logger,
  level: :debug,
  console: [format: "[$level] $message\n"]

config :time_zone_info, utc_datetime: FakeUtcDateTime

config :time_zone_info_server, iana_data_path: "../../test/fixtures/iana"
