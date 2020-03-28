defmodule TimeZoneInfo.Downloader.Mint do
  @moduledoc """
  An implementation of the `TimeZoneInfo.Downloader` behaviour using `Mint`.
  """

  @behaviour TimeZoneInfo.Downloader

  alias Mint.HTTP

  @impl true
  def download(uri, opts) do
    method = "GET"
    headers = opts[:headers] || []
    http = http!()

    with {:ok, conn} <- http.connect(scheme(uri), uri.host, uri.port),
         {:ok, conn, request_ref} <- http.request(conn, method, uri.path, headers, ""),
         {:ok, conn, body} <- receive_response(conn, request_ref),
         {:ok, _conn} <- http.close(conn) do
      {:ok, body}
    else
      error -> {:error, error}
    end
  end

  defp receive_response(conn, request_ref, body \\ []) do
    {conn, body, status} = receive_message(conn, request_ref, body)

    case status do
      :incomplete -> receive_response(conn, request_ref, body)
      :complete -> {:ok, conn, Enum.join(body)}
    end
  end

  defp receive_message(conn, request_ref, body) do
    http = HTTP

    receive do
      message ->
        {:ok, conn, responses} = http.stream(conn, message)

        {body, status} =
          Enum.reduce(responses, {body, :incomplete}, fn response, {body, _status} ->
            case response do
              {:data, ^request_ref, data} ->
                {body ++ [data], :incomplete}

              {:done, ^request_ref} ->
                {body, :complete}

              {_, ^request_ref, _} ->
                {body, :incomplete}
            end
          end)

        {conn, body, status}
    end
  end

  defp scheme(%{scheme: "http"}), do: :http

  defp scheme(%{scheme: "https"}), do: :https

  defp http! do
    case Code.ensure_loaded?(HTTP) do
      true ->
        HTTP

      false ->
        raise """
        Can't find dependency for Mint. Please add :mint to your deps.

        defp deps do
          [
            {:mint, "~> 1.0"},
            {:castore, "~> 0.1"},
            ...
          ]
        end
        """
    end
  end
end
