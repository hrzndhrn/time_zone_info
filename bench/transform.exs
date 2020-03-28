defmodule Bench.Transform do
  alias TimeZoneInfo.{IanaParser, Transformer}

  def run do
    Benchee.run(
      %{transform: &transform/0},
      formatters: formatters(),
      time: 10,
      title: "Benchmark: Transform"
    )
  end

  defp formatters do
    [
      Benchee.Formatters.Console,
      {Benchee.Formatters.Markdown,
       file: Path.expand("trnasformer.md", __DIR__),
       description: """
       This benchmark measures the performance of the transformation of the
       raw IANA data to the data structure used by `TimeZoneInfo`.
       """}
    ]
  end

  defp transform do
    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    with {:ok, data} <- IanaParser.parse(path, files) do
      Transformer.transform(data, "2019c", lookahead: 15)
    end
  end
end
