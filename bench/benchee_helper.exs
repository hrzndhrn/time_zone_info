alias TimeZoneInfo.{DataStore, ExternalTermFormat}

Application.ensure_all_started(:tzdata)

{:ok, data} = "priv/data.etf" |> File.read!() |> ExternalTermFormat.decode()

DataStore.put(data)

BencheeDsl.run(
  time: 10,
  memory_time: 5,
  pre_check: true
)
