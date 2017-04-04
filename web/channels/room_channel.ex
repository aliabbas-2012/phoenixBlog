defmodule BlogTest.RoomChannel do
  use Phoenix.Channel
  
  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "------------"
    {:error, %{reason: "you can only join the lobby"}}
  end

  def handle_in("new_message", body, socket) do
   broadcast! socket, "new_message", body
   {:noreply, socket}
 end
end
