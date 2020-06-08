alias BencheeDsl.Benchmark
alias TimeZoneInfo.{DataStore, ExternalTermFormat}

Application.ensure_all_started(:tzdata)

Code.require_file("bench/data.exs")
Code.require_file("test/support/time_zone_info/data_store/server.exs")

{:ok, data} = "test/fixtures/data/2020a/data.etf" |> File.read!() |> ExternalTermFormat.decode()

DataStore.PersistentTerm.put(data)
DataStore.ErlangTermStorage.put(data)
DataStore.Server.put(data)

BencheeDsl.config(
  before_each_benchmark: fn benchmark ->
    file = Path.join(benchmark.dir, Macro.underscore(benchmark.module) <> ".md")

    Benchmark.update(benchmark, [:config, :formatters], fn formatters ->
      formatter = {
        Benchee.Formatters.Markdown,
        file: file, description: benchmark.description
      }

      [formatter | formatters]
    end)
  end
)

BencheeDsl.run(
  time: 10,
  memory_time: 2
)
