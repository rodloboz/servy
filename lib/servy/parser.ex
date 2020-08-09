defmodule Servy.Parser do
  @moduledoc false

  alias Servy.Conn

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split

    %Conn{ method: method, path: path }
  end
end