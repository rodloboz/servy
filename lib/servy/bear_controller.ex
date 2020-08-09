defmodule Servy.BearController do

  alias Servy.Bear
  alias Servy.Conn
  alias Servy.Wildthings

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]

  defp bear_item(bear) do
    "<li>#{bear.name}</li>"
  end

  def index(%Conn{} = conn) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_ascending_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join
    bears_html = """
    <ul>
      #{items}
    </ul>
    """
    body = "<h1 class=\"large\">Bears</h1>" <> bears_html
    %{ conn | status: 200, resp_body: body }
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    body = "<h1 class=\"large\">#{bear.name}</h1>"
    %{ conn | status: 200, resp_body: body  }
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