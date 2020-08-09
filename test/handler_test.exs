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

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 345\r
    \r
    <h1>Bears</h1>

    <ul>
      <li>Brutus is a Grizzly bear</li>
      <li>Ming is a Panda bear</li>
      <li>Paddington is a Brown bear</li>
      <li>Rosie is a Black bear</li>
      <li>Scarface is a Grizzly bear</li>
      <li>Smokey is a Black bear</li>
      <li>Snow is a Polar bear</li>
      <li>Teddy is a Brown bear</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end