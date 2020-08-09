defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 47\r
    \r
    <h1 class="large">Lions, Bears, and Tigers</h1>
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 345\r
    \r
    <h1>Bears</h1>\n\n<ul>\n  \n    <li>Brutus is a Grizzly bear</li>\n  \n    <li>Ming is a Panda bear</li>\n  \n    <li>Paddington is a Brown bear</li>\n  \n    <li>Rosie is a Black bear</li>\n  \n    <li>Scarface is a Grizzly bear</li>\n  \n    <li>Smokey is a Black bear</li>\n  \n    <li>Snow is a Polar bear</li>\n  \n    <li>Teddy is a Brown bear</li>\n  \n</ul>
    """
  end
end