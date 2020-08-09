defmodule Servy.View do
  @moduledoc false

  alias Servy.Conn

  @templates_path Path.expand("../../templates", __DIR__)

  def render(%Conn{} = conn, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

      %{ conn | status: 200, resp_body: content }
  end
end