defmodule Servy.Parser do
  @moduledoc false

  alias Servy.Conn

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _version] = String.split(request_line)
      # top
      # |> String.split("\n")
      # |> List.first
      # |> String.split

    headers = parse_headers(header_lines, %{})
    params = parse_params(params_string)

    %Conn{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params(params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end