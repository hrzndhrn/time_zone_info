defmodule TransformBench do
  use BencheeDsl.Benchmark

  alias TimeZoneInfo.{IanaParser, Transformer}

  @title "Benchmark: Transform"

  @description """
  This benchmark measures the performance of the transformation of the
  raw IANA data to the data structure used by `TimeZoneInfo`.
  """

  config time: 60

  job transform do
    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    with {:ok, data} <- IanaParser.parse(path, files) do
      Transformer.transform(data, "2019c", lookahead: 15)
    end
  end
end