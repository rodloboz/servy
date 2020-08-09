defmodule Servy.Wildthings do
  @moduledoc false

  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black"},
      %Bear{id: 3, name: "Paddington", type: "Brown"},
      %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar"},
      %Bear{id: 6, name: "Brutus", type: "Grizzly"},
      %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
      %Bear{id: 8, name: "Ming", type: "Panda"}
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end