defmodule Servy.Api.BearController do
  @moduledoc false

  alias Servy.Conn
  alias Servy.Wildthings

  def index(%Conn{} = conn) do
    json =
      Wildthings.list_bears()
      |> Poison.encode!

    %{ conn |
        status: 200,
        resp_content_type: "application/json",
        resp_body: json
    }
  end
end