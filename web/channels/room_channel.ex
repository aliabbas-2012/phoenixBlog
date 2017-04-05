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

  def handle_in("room_msg", %{"body"=>body} = payload, socket) do
   IO.puts "-----in message braoding casting-------"
   IO.inspect body
   IO.inspect socket

   broadcast! socket, "room_msg", %{body: body,calling_name: socket.assigns.calling_name}
   {:noreply, socket}
 end

 def handle_out("room_msg", payload, socket) do
    IO.puts "-----out message-------"
   push socket, "room_msg", payload
   {:noreply, socket}
 end
end
