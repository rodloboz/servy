defmodule Servy.Handler do

  @moduledoc "Handles HTTP Requests."

  alias Servy.Conn

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [
    rewrite_path: 1,
    log: 1,
    track: 1
  ]

  @doc "Transforms the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  # def route(conv) do
  #   # Map.put(conv, :resp:body, "Bears, Lions, Tigers")
  #   # %{ conv | resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
  #   route conv, conv.method, conv.path
  # end

  def route(%Conn{ method: "GET", path: "/wildthings" } = conn) do
    %{ conn | status: 200, resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
  end

  def route(%Conn{ method: "GET", path: "/bears" } = conn) do
    %{ conn | status: 200, resp_body: "<h1 class=\"large\">Bears</h1>" }
  end

  # name=Babaloo&type=Brown
  def route(%Conn{ method: "POST", path: "/bears" } = conn) do
    # params = %{ "name" => "Babaloo", "type" => "Brown" }
    %{ conn | status: 201, resp_body: "Created #{conn.params["name"]} #{conn.params["type"]} bear!" }
  end

  def route(%Conn{ method: "GET", path: "/bears/new" } = conn) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conn)
  end

  def route(%Conn{ method: "GET", path: "/bears/" <> id } = conn) do
    %{ conn | status: 200, resp_body: "<h1 class=\"large\">Bear #{id}</h1>" }
  end

  def route(%Conn{ method: "DELETE", path: "/bears/" <> id } = conn) do
    %{ conn | status: 403, resp_body: "Cannot delete Bear #{id}" }
  end

  def route(%Conn{ method: "GET", path: "/" } = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conn)
  end

  # def route(%{ method: "GET", path: "/" } = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{ conv | status: 200, resp_body: content }

  #     {:error, :enoent} ->
  #       %{ conv | status: 404, resp_body: "File not found" }

  #     {:error, reason} ->
  #       %{ conv | status: 500, resp_body: "File error: #{reason}" }
  #   end
  # end

  # Catch all route
  def route(%Conn{ method: method, path: path } = conn) do
    %{ conn | status: 404, resp_body: "404 - Cound not find #{method} request for #{path}" }
  end

  def format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.full_status(conn)}
    Content-Type: text/html
    Content-Length: #{byte_size(conn.resp_body)}

    #{conn.resp_body}
    """
  end
end


# Request
# Request line: HTTP Verb, HTTP URI and HTTP Protocol
# Headers line
# UserAgent line
# Accept line
# Blank line (separates headers from body)
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# HTTP Response
# Status Line: HTTP Protocol, Status Code, Reason Phrase
# Response Headers: Media Type and Size of the Body
# Blank line (sep headers from body)
# Body
expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 47

<h1 class="large">Lions, Bears, and Tigers</h1>
"""

response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET / HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)
IO.puts(response)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Babaloo&type=Brown
"""
response = Servy.Handler.handle(request)
IO.puts(response)