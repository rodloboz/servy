defmodule Servy.PledgeServer do

  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface
  def start_link(_arg) do
    IO.puts "Starting the Pledge Server... 💰"
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do
    GenServer.cast @name, :clear_cache
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server Callbacks
  def init(%State{} = state) do
    pledges = fetch_recent_pledges_from_server()
    new_state = %{ state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear_cache, %State{} = state) do
    {:noreply, %{ state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, %State{} = state) do
    {:noreply, %{ state | cache_size: size}}
  end

  def handle_call(:total_pledged, _from, %State{} = state) do
    total = Enum.map(state.pledges , &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, %State{} = state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, %State{} = state) do
    { :ok, id } = send_pledge_to_server(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [ {name, amount} | most_recent_pledges ]
    {:reply, id, %{state | pledges: cached_pledges}}
  end

  def handle_info(_message, state) do
    IO.puts "Can't touch this!"
    {:noreply, state}
  end

  defp fetch_recent_pledges_from_server do
    # FETCH PLEDGES FROM SERVICE
    [ {"larry", 20}, {"holmes", 69}]
  end

  defp send_pledge_to_server(_name, _amount) do
    # SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
