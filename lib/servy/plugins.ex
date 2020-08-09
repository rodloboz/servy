defmodule Servy.Plugins do
  @moduledoc false

  alias Servy.Conn

  require Logger

  @doc "Logs 404 requests"
  def track(%Conn{status: 404, path: path} = conn) do
    if Mix.env !=:test do
      Logger.error "Cannot find #{path}!"
    end
    conn
  end

  def track(%Conn{} = conn), do: conn

  # def rewrite_path(%{ path: "/bears?id=" <> id} = conv) do
  #   %{ conv | path: "/bears/#{id}" }
  # end

  def rewrite_path(%Conn{ path: "/wildlife"} = conn) do
    %{ conn | path: "/wildthings" }
  end

  def rewrite_path(%Conn{path: path} = conn) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conn, captures)
  end

  def rewrite_path(%Conn{} = conn), do: conn

  def rewrite_path_captures(conn, %{"thing" => thing, "id" => id}) do
    %{ conn | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(%Conn{} = conn, nil), do: conn

  def log(%Conn{} = conn) do
    if Mix.env== :dev do
      IO.inspect conn
    end
    conn
  end
end