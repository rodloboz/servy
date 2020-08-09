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

    params = parse_params(params_string)

    %Conn{ method: method, path: path, params: params }
  end

  def parse_params(params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end
end