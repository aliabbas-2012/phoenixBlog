defmodule BlogTest.RoomChannel do
  use BlogTest.Web, :channel
  alias BlogTest.Presence

  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.Message
  alias BlogTest.Image
  alias BlogTest.ApplicationHelpers

  import Ecto.Query

  def join("rooms:"<> roomId, _message, socket) do
    send(self, :after_join)
    # room = Repo.get!(Room,roomId)
    IO.puts "---HERE---in room------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the lobby"}}
  end

  def handle_info(:after_join, socket) do
     IO.puts "------handle info presense state-------"
     IO.inspect  Presence.list(socket)
     push socket, "presence_state", Presence.list(socket)
     {:ok, _} = Presence.track(socket, socket.assigns.auth.user_id, %{
       status_at: :os.system_time(:milli_seconds),
       status: "online"
     })
     {:noreply, socket}
  end

  def handle_in("room_msg", %{"body"=>body} = payload, socket) do
   msg_sender = Repo.get(User,socket.assigns.auth.user_id) |> Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))
   broadcast! socket, "room_msg", %{
          body: body,
          sender: ApplicationHelpers.user_full_name(msg_sender),
          sender_id: msg_sender.id,
          sender_logo: ApplicationHelpers.logo_image(msg_sender),
          timestamp: :os.system_time(:millisecond)
        }
   {:noreply, socket}
 end
 #manage status
 def handle_in("new_status", %{"status" => status}, socket) do
    IO.puts "-------new status of current user------"
    IO.puts status
    {:ok, _} = Presence.update(socket, socket.assigns.auth.user_id, %{
      status: status,
      status_at: :os.system_time(:milli_seconds),
    })
    IO.puts status
    {:noreply, socket}
 end
 # user is typing
 def handle_in("user_typing", %{"status" => status}, socket) do
    IO.puts "-------new status of user typing-----"
    IO.puts status
    broadcast! socket, "user_typing", %{
           helping_text: "#{ApplicationHelpers.user_full_name(socket.assigns.auth.user)} is typing...",
           typing_by: socket.assigns.auth.user.id,
           status: status
    }
    {:noreply, socket}
 end

 intercept ["room_msg"]
 def handle_out("room_msg", %{body: body, sender: sender,sender_id: sender_id} = payload, socket) do
    IO.puts "-----out and save message-------"
    save_message(body,sender_id,List.last(String.split(socket.topic,":")))
    push socket, "room_msg", payload
    {:noreply, socket}
 end

 intercept ["user_typing"]
 def handle_out("user_typing", %{typing_by: typing_by} = payload, socket) do
    #avoid current user to see who is typing
    if socket.assigns.auth.user.id != typing_by do
      IO.puts "---user typing handle out"
      IO.inspect payload
      push socket, "user_typing", payload
    end
    {:noreply, socket}
 end

 #save message in database
 defp save_message(body,sender_id,room_id) do
   message_params = %{user_id: sender_id,room_id: room_id,content: body}
   IO.inspect message_params
   Message.changeset(%Message{}, message_params) |> Repo.insert!
 end
end
