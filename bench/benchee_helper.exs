Code.require_file("test/support/time_zone_info/data_store/server.exs")

Application.ensure_all_started(:tzdata)

BencheeDsl.config(
  before_each_benchmark: fn benchmark ->
    file_name =
      case benchmark.module do
        TimeZoneDatabaseBench -> "README.md"
        module -> Macro.underscore(module) <> ".md"
      end

    file = Path.join(benchmark.dir, file_name)

    update_in(benchmark, [:config, :formatters], fn formatters ->
      formatter = {Benchee.Formatters.Markdown, file: file, description: benchmark.description}
      [formatter|formatters]
    end)
    |> IO.inspect
  end
)

BencheeDsl.run(
  time: 10,
  memory_time: 2
)