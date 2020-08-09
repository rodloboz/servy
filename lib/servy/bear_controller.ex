defmodule Servy.BearController do

  alias Servy.Bear
  alias Servy.Conn
  alias Servy.Wildthings

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.View, only: [render: 3]

  def index(%Conn{} = conn) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_ascending_by_name/2)

    render(conn, "index.eex", bears: bears)
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conn, "show.eex", bear: bear)
  end

  def new(%Conn{} = conn) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conn)
  end

  def create(%Conn{} = conn, %{"name" => name, "type" => type}) do
    body = "Created #{name} #{type} bear!"
    %{ conn | status: 201, resp_body: body  }
  end

  def destroy(%Conn{} = conn, %{"id" => id}) do
    body = "Cannot delete Bear #{id}"
    %{ conn | status: 403, resp_body: body }
  end
end