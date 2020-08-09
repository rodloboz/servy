defmodule Servy.Handler do
  @moduledoc false

  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    # TODO: Parse the request string into a map
    conv = %{ method: "GET", path: "/wildthings", resp_body: "" }
  end

  def route(conv) do
    # TODO: Create a new map that also has the response body:
    conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
  end

  def format_response(conv) do
    # TODO: User values in the map to create an HTTP response string:
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end


# Request
# Request line: HTTP Verb, HTTP URI and HTTP Version
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
# Status Line: HTTP version, Status Code, Reason Phrase
# Response Headers: Media Type and Size of the Body
# Blank line (sep headers from body)
# Body
expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers

"""

response = Servy.Handler.handle(request)
IO.puts(response)