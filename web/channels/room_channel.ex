defmodule BlogTest.RoomChannel do
  use Phoenix.Channel
  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.Message
  alias BlogTest.Image
  alias BlogTest.ApplicationHelpers
  import Ecto.Query

  def join("rooms:"<> roomId, _message, socket) do
      room = Repo.get!(Room,roomId)
      IO.puts "------in #{room.name}------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the lobby"}}
  end

  def handle_in("room_msg", %{"body"=>body} = payload, socket) do
   msg_sender = Repo.get(User,socket.assigns.auth.user_id) |> Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))


   broadcast! socket, "room_msg", %{body: body,sender: ApplicationHelpers.user_full_name(msg_sender),sender_id: msg_sender.id,sender_logo: ApplicationHelpers.logo_image(msg_sender) }
   {:noreply, socket}
 end

 intercept ["room_msg"]
 def handle_out("room_msg", %{body: body, sender: sender,sender_id: sender_id} = payload, socket) do
    IO.puts "-----out and save message-------"
    save_message(body,sender_id,List.last(String.split(socket.topic,":")))
    push socket, "room_msg", payload
    {:noreply, socket}
 end

 #save message in database
 defp save_message(body,sender_id,room_id) do
   message_params = %{user_id: sender_id,room_id: room_id,content: body}
   IO.inspect message_params
   Message.changeset(%Message{}, message_params) |> Repo.insert!
 end
end
