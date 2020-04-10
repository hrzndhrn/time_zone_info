defmodule TimeZoneInfo.Downloader do
  @moduledoc """
  The behaviour for downloaders.
  """

  @typedoc """
  The expected format for the download.

  `TimeZoneInfo` expected for
  - :iana the zipped tar archive with IANA data.
  - :etf a compressed file in the
    [External Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html).
  """
  @type format :: :iana | :etf

  @typedoc "HTTP headers."
  @type headers() :: [{header_name :: String.t(), header_value :: String.t()}]

  @type opts :: [
          headers: headers(),
          format: format()
        ]

  @typedoc "HTTP status code"
  @type status_code :: non_neg_integer()

  @type download :: {:ok, format(), {status_code(), binary()}}

  @formats ~w(iana etf)a

  @callback download(uri :: URI.t(), opts :: opts) :: download() | {:error, term()}

  def download do
    with {:ok, uri} <- uri(),
         {:ok, format} <- format(),
         {:ok, opts} <- opts(),
         {:ok, data} <- impl().download(uri, opts),
         do: {:ok, format, data}
  end

  @spec impl :: module()
  defp impl do
    :time_zone_info
    |> Application.get_env(:downloader)
    |> Keyword.fetch!(:module)
  end

  @spec format :: {:ok, format()} | {:error, term()}
  defp format do
    with {:ok, value} <- fetch_env(:format) do
      case value in @formats do
        true -> {:ok, value}
        false -> {:error, {:invalid_config, [downloader: [format: value]]}}
      end
    end
  end

  @spec uri :: {:ok, URI.t()} | {:error, term()}
  defp uri do
    with {:ok, uri} <- fetch_env(:uri) do
      {:ok, URI.parse(uri)}
    end
  end

  @spec opts :: {:ok, keyword()} | {:error, term()}
  defp opts do
    with {:ok, opts} <- fetch_env() do
      opts =
        opts
        |> Keyword.delete(:module)
        |> Keyword.delete(:uri)

      {:ok, opts}
    end
  end

  @spec fetch_env :: {:ok, keyword()} | {:error, term()}
  defp fetch_env do
    with :error <- Application.fetch_env(:time_zone_info, :downloader) do
      {:error, {:invalid_config, :downloader}}
    end
  end

  @spec fetch_env(Keyword.key()) :: {:ok, term()} | {:error, term()}
  defp fetch_env(key) do
    with {:ok, env} <- fetch_env(),
         :error <- Keyword.fetch(env, key) do
      {:error, {:invalid_config, [:downloader, key]}}
    end
  end
end
