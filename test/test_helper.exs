~w(
  test_plug.exs
  time_zone_info/checker.exs
  time_zone_info/data_store/server.exs
  time_zone_info/perl_checker.exs
  time_zone_info/test_utils.exs
  time_zone_info/time_zone_database_case.exs
  time_zone_info/time_zone_database_checker.exs
  time_zone_info/tz_checker.exs
  time_zone_info/tzdata_checker.exs
  time_zone_info_case.exs
)
|> Enum.each(fn file ->
  "support" |> Path.join(file) |> Code.require_file(__DIR__)
end)

Mox.defmock(TimeZoneInfo.DataPersistenceMock, for: TimeZoneInfo.DataPersistence)
Mox.defmock(TimeZoneInfo.DataStoreMock, for: TimeZoneInfo.DataStore)
Mox.defmock(TimeZoneInfo.DownloaderMock, for: TimeZoneInfo.Downloader)
Mox.defmock(TimeZoneInfo.UpdaterMock, for: TimeZoneInfo.Updater.Interface)

Application.ensure_all_started(:mox)

config =
  if System.get_env("CI") do
    [
      max_runs: 10_000,
      timeout: 60_000,
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

Application.ensure_all_started(:cowboy)

Supervisor.start_link(
  [{Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: 1234]}],
  strategy: :one_for_one,
  name: MyApp.Supervisor
)

Logger.configure(level: :info)

ExUnit.start(timeout: config[:timeout])
