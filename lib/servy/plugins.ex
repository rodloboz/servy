defmodule Servy.Plugins do
  @moduledoc false

  require Logger

  alias Servy.Conn

  @doc "Logs 404 requests"
  def track(%Conn{status: 404, path: path} = conn) do
    Logger.error "Cannot find #{path}!"
    conn
  end

  def track(conn), do: conn

  def rewrite_path(%Conn{ path: "/wildlife"} = conn) do
    %{ conn | path: "/wildthings" }
  end

  # def rewrite_path(%{ path: "/bears?id=" <> id} = conv) do
  #   %{ conv | path: "/bears/#{id}" }
  # end

  def rewrite_path(%Conn{path: path} = conn) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conn, captures)
  end

  def rewrite_path_captures(conn, %{"thing" => thing, "id" => id}) do
    %Conn{ conn | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conn, nil), do: conn

  def rewrite_path(conn), do: conn

  def log(conn), do: IO.inspect conn
end