defmodule Servy.Conn do
  @moduledoc false

  defstruct [
    method: "",
    path: "",
    params: %{},
    headers: %{},
    resp_body: "",
    status: nil,
    content_type: "text/html"
]

  def full_status(conn) do
    "#{conn.status} #{status_reason(conn.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end