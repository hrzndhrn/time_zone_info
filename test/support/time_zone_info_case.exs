defmodule TimeZoneInfoCase do
  use ExUnit.CaseTemplate

  alias TimeZoneInfo.{DataStore, IanaParser, Transformer}

  using do
    quote do
      import TimeZoneInfoCase
    end
  end

  setup_all do
    lookahead = 2040 - NaiveDateTime.utc_now().year

    Application.put_env(:time_zone_info, :data_store, TimeZoneInfo.DataStore.Server)

    path = "test/fixtures/iana/2019c"
    files = ~w(africa antarctica asia australasia etcetera europe northamerica southamerica)

    with {:ok, data} <- IanaParser.parse(path, files) do
      data
      |> Transformer.transform("2019c", lookahead: lookahead)
      |> DataStore.put()
    end

    :ok
  end
end
