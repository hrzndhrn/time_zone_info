defmodule TransformBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.{IanaParser, Transformer}

  @title "Benchmark: Transform"

  @description """
  This benchmark measures the performance of the transformation of the
  raw IANA data to the data structure used by `TimeZoneInfo`.
  """

  formatter Benchee.Formatters.Markdown,
    file: Path.join(["bench", "reports", Macro.underscore(__MODULE__) <> ".md"]),
    title: @title,
    description: @description

  config time: 60

  job transform do
    path = "test/fixtures/iana/2019c"

    files = [
      "africa",
      "antarctica",
      "asia",
      "australasia",
      "etcetera",
      "europe",
      "northamerica",
      "southamerica"
    ]

    with {:ok, data} <- IanaParser.parse(path, files) do
      Transformer.transform(data, "2019c", lookahead: 15, files: files, time_zones: :all)
    end
  end
end
