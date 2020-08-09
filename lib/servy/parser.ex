defmodule Servy.Parser do
  @moduledoc false

  alias Servy.Conn

  def parse(request) do
    request_parts = String.split(request, "\r\n\r\n")
    top = Enum.at request_parts, 0
    params_string = Enum.at request_parts, 1

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _version] = String.split(request_line)
      # top
      # |> String.split("\n")
      # |> List.first
      # |> String.split

    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)

    %Conn{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with the corresponding keys and values.

  ## Examples
    iex> params_string = "name=Babaloo&type=Brown"
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
    %{"name" => "Babaloo", "type" => "Brown"}
    iex> Servy.Parser.parse_params("multipart/form-data", params_string)
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  # def parse_headers([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_headers(tail, headers)
  # end

  # def parse_headers([], headers), do: headers

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers, key, value)
    end)
  end
end