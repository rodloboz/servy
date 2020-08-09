defmodule Servy.BearController do
  alias Servy.Conn

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]

  def index(%Conn{} = conn) do
    body = "<h1 class=\"large\">Bears</h1>"
    %{ conn | status: 200, resp_body: body }
  end

  def show(%Conn{} = conn, id) do
    body = "<h1 class=\"large\">Bear #{id}</h1>"
    %{ conn | status: 200, resp_body: body  }
  end

  def new(%Conn{} = conn) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conn)
  end

  def create(%Conn{} = conn) do
    body = "Created #{conn.params["name"]} #{conn.params["type"]} bear!"
    %{ conn | status: 201, resp_body: body  }
  end

  def destroy(%Conn{} = conn, id) do
    body = "Cannot delete Bear #{id}"
    %{ conn | status: 403, resp_body: body }
  end
end