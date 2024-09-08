"test/support/**/*.exs"
|> Path.wildcard()
|> Enum.each(&Code.require_file/1)

Mox.defmock(TimeZoneInfo.DataPersistenceMock, for: TimeZoneInfo.DataPersistence)
Mox.defmock(TimeZoneInfo.DataStoreMock, for: TimeZoneInfo.DataStore)
Mox.defmock(TimeZoneInfo.DownloaderMock, for: TimeZoneInfo.Downloader)
Mox.defmock(TimeZoneInfo.UpdaterMock, for: TimeZoneInfo.Updater)

Application.ensure_all_started(:mox)

config =
  if System.get_env("CI") do
    [
      max_runs: 10_000,
      timeout: 60_000 * 3,
      checker: []
    ]
  else
    [
      max_runs: 10,
      timeout: 60_000,
      checker: [
        [
          mod: TimeZoneInfo.TzChecker,
          info: false,
          assert: false,
          active: false
        ],
        [
          mod: TimeZoneInfo.TzdataChecker,
          info: false,
          assert: false,
          active: false
        ],
        [
          mod: TimeZoneInfo.PerlChecker,
          info: false,
          assert: false,
          active: false
        ]
      ]
    ]
  end

Application.put_env(:tzdata, :autoupdate, :disabled)

tzdata? = fn checker -> checker[:mod] == TimeZoneInfo.TzdataChecker && checker[:active] end
if Enum.find(config[:checker], tzdata?), do: Application.ensure_all_started(:tzdata)
Application.put_env(:time_zone_info, :checker, config[:checker])

Application.ensure_started(:stream_data)
Application.put_env(:stream_data, :max_runs, config[:max_runs])

Application.ensure_all_started(:telemetry)
Application.ensure_all_started(:cowboy)

Supervisor.start_link(
  [{Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: 1234]}],
  strategy: :one_for_one,
  name: MyApp.Supervisor
)

# extract IANA tzdb for tests

tzdata = "tzdata2024b.tar.gz"
# tzdata = "tzdata2019c.tar.gz"
fixture = ~c"test/fixtures/iana/#{tzdata}"
File.exists?(fixture) || raise("missing #{fixture}")

iana_temp = ~c"test/temp/iana"
File.mkdir_p!(iana_temp)

files = [
  ~c"africa",
  ~c"antarctica",
  ~c"asia",
  ~c"australasia",
  ~c"backward",
  ~c"etcetera",
  ~c"europe",
  ~c"northamerica",
  ~c"southamerica"
]

:erl_tar.extract(fixture, [:compressed, {:cwd, iana_temp}, {:files, files}])

Logger.configure(level: :info)

ExUnit.start(timeout: config[:timeout])
