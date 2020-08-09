defmodule Servy.Handler do
  @moduledoc false

  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split

    %{ method: method, path: path, status: nil, resp_body: "" }
  end

  def route(conv) do
    # Map.put(conv, :resp:body, "Bears, Lions, Tigers")
    # %{ conv | resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | status: 200, resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | status: 200, resp_body: "<h1 class=\"large\">Bears</h1>" }
  end

  def route(conv, "GET", _) do
    %{ conv | status: 404, resp_body: "404 - Not found" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
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