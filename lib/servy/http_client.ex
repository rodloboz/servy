# client() ->
#   SomeHostInNet = "localhost", % to make it runnable on one machine
#   {ok, Sock} = gen_tcp:connect(SomeHostInNet, 5678,
#                                [binary, {packet, 0}]),
#   ok = gen_tcp:send(Sock, "Some Data"),
#   ok = gen_tcp:close(Sock).

defmodule Servy.HttpClient do
  @moduledoc false

  def start(host \\ 'localhost', port \\ 8080) do
    {:ok, socket} = :gen_tcp.connect(host, port,
                                  [:binary, packet: :raw, active: false])

    IO.puts "\n⚡️  Connected client to host #{host} on port #{port}...\n"

    send(socket)
  end

  def send(socket) do
    socket
    |> send_request
    |> get_response
    |> close_connection
  end

  def send_request(socket) do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    :ok = :gen_tcp.send(socket, request)

    IO.puts "➡️  Sent request:\n"
    IO.puts request

    socket
  end

  def get_response(socket) do
    {:ok, response} = :gen_tcp.recv(socket, 0)

    IO.puts "➡️  Received response:\n"
    IO.inspect response

    socket
  end

  def close_connection(socket) do
    :ok = :gen_tcp.close(socket)

    IO.puts "Closed connection\n"
  end
end