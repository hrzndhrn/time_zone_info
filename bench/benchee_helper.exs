alias BencheeDsl.Benchmark
alias TimeZoneInfo.{DataStore, IanaParser, Transformer}

Application.ensure_all_started(:tzdata)

Code.require_file("bench/data.exs")
Code.require_file("test/support/time_zone_info/data_store/server.exs")

path = "test/fixtures/iana/2019c"
files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

time_zone_info_data =
  with {:ok, data} <- IanaParser.parse(path, files) do
    Transformer.transform(data, "2019c", lookahead: 5)
  end

DataStore.PersistentTerm.put(time_zone_info_data)
DataStore.ErlangTermStorage.put(time_zone_info_data)
DataStore.Server.put(time_zone_info_data)

BencheeDsl.config(
  before_each_benchmark: fn benchmark ->
    file_name =
      case benchmark.module do
        TimeZoneDatabaseBench -> "README.md"
        module -> Macro.underscore(module) <> ".md"
      end

    file = Path.join(benchmark.dir, file_name)

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
