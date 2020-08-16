defmodule Servy.PledgeController do
  alias Servy.Conn
  alias Servy.PledgeServer

  def index(%Conn{} = conn) do
    pledges = PledgeServer.recent_pledges()

    %{ conn | status: 200, resp_body: (inspect pledges)  }
  end

  def create(%Conn{} = conn, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge(name, String.to_integer(amount))
    body = "#{name} pledged #{amount}!"

    %{ conn | status: 201, resp_body: body  }
  end
end