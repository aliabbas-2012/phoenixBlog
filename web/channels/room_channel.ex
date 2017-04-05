defmodule BlogTest.RoomChannel do
  use Phoenix.Channel

  def join("rooms:lobby", _message, socket) do
      IO.puts "------in lobby------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the lobby"}}
  end

  def handle_in("room_msg", body, socket) do
   IO.puts "-----in message-------"
   broadcast! socket, "room_msg", body
   {:noreply, socket}
 end

 def handle_out("room_msg", payload, socket) do
    IO.puts "-----out message-------"
   push socket, "room_msg", payload
   {:noreply, socket}
 end
end
