defmodule Servy.Handler do
  @moduledoc false

  require Logger

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.error "Cannot find #{path}!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  # def rewrite_path(%{ path: "/bears?id=" <> id} = conv) do
  #   %{ conv | path: "/bears/#{id}" }
  # end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split

    %{
      method: method,
      path: path,
      status: nil,
      resp_body: ""
    }
  end

  # def route(conv) do
  #   # Map.put(conv, :resp:body, "Bears, Lions, Tigers")
  #   # %{ conv | resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
  #   route conv, conv.method, conv.path
  # end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "<h1 class=\"large\">Lions, Bears, and Tigers</h1>" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "<h1 class=\"large\">Bears</h1>" }
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "<h1 class=\"large\">Bear #{id}</h1>" }
  end

  def route(%{ method: "DELETE", path: "/bears/" <> id } = conv) do
    %{ conv | status: 403, resp_body: "Cannot delete Bear #{id}" }
  end

  def route(%{ method: "GET", path: "/" } = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({:ok, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({:ok, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}" }
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
  def route(%{ method: method, path: path } = conv) do
    %{ conv | status: 404, resp_body: "404 - Cound not find #{method} request for #{path}" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
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