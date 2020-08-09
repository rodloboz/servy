defmodule Servy.FileHandler do
  @moduledoc false

  alias Servy.Conn

  def handle_file({:ok, content}, %Conn{} = conn) do
    %{ conn | status: 200, resp_body: content }
  end

  def handle_file({:ok, :enoent}, %Conn{} = conn) do
    %{ conn | status: 404, resp_body: "File not found" }
  end

  def handle_file({:ok, reason}, %Conn{} = conn) do
    %{ conn | status: 500, resp_body: "File error: #{reason}" }
  end
end