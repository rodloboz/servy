defmodule Servy.PledgeServerHandRolled do

  alias Servy.GenericServer

  @name :pledge_server_hand_rolled

  # Client Interface
  def start do
    GenericServer.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenericServer.call @name, :total_pledged
  end

  def clear do
    GenericServer.cast @name, :clear_cache
  end

  # Server Callbacks
  def handle_cast(:clear_cache, _state), do: []

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state), do: {state, state}

  def handle_call({:create_pledge, name, amount}, state) do
    { :ok, id } = send_pledge_to_server(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges ]
    {id, new_state}
  end

  defp send_pledge_to_server(_name, _amount) do
    # SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
