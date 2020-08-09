defmodule Servy.Conn do
  @moduledoc false

  defstruct [method: "", path: "", resp_body: "", status: nil]
end