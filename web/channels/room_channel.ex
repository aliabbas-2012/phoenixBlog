defmodule BlogTest.RoomChannel do
  use BlogTest.Web, :channel


  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.Message
  alias BlogTest.Notification
  alias BlogTest.Image
  alias BlogTest.ApplicationHelpers
  import Ecto.Query


  def join("rooms:"<> roomId, _message, socket) do

    # room = Repo.get!(Room,roomId)
    IO.puts "---HERE---in room------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the lobby"}}
  end


  def handle_in("room_msg", %{"body"=>body} = payload, socket) do
   msg_sender = Repo.get(User,socket.assigns.auth.user_id) |> Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))
   message = %{
          body: body,
          sender: ApplicationHelpers.user_full_name(msg_sender),
          sender_id: msg_sender.id,
          sender_logo: ApplicationHelpers.logo_image(msg_sender),
          timestamp: :os.system_time(:millisecond)
        }
   broadcast! socket, "room_msg", message
   #save message to database
   save_message(message,socket,List.last(String.split(socket.topic,":")))
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

 intercept ["room_msg","user_typing"]
 def handle_out(event,payload, socket) do
   case  event do
     "room_msg" ->
        send_message(payload,socket,List.last(String.split(socket.topic,":")))
     "user_typing" ->
         user_typing_call_back(payload,socket)
   end
    IO.inspect event
    IO.puts "-----out and sending message-------"
    {:noreply, socket}
 end

 #Leave user
 def terminate(reason, socket) do
    IO.puts socket.assigns.auth.user.first_name
    IO.puts "-------------"
    IO.puts "> leave #{inspect reason}"

    message = %{
           body: "left the room ",
           leaving_by: ApplicationHelpers.user_full_name(socket.assigns.auth.user),
           timestamp: :os.system_time(:millisecond)
         }
    broadcast! socket, "leave_room", message
    :ok
 end


 defp user_typing_call_back(%{typing_by: typing_by} = payload, socket) do
    #avoid current user to see who is typing
    if socket.assigns.auth.user.id != typing_by do
      IO.puts "---user typing handle out"
      IO.inspect payload
      push socket, "user_typing", payload
    end
    {:noreply, socket}
 end

 #save message in database
 defp save_message(%{body: body, sender: sender,sender_id: sender_id} = payload,socket,room_id) do
   message_params = %{user_id: sender_id,room_id: room_id,content: body}
   IO.inspect message_params
   message = Message.changeset(%Message{}, message_params) |> Repo.insert!
   save_notification(message)

 end
 #save message
 defp save_notification(message,is_seen \\ false) do
   message_params = %{message_id: message.id,is_seen: is_seen}
   Notification.changeset(%Notification{}, message_params) |> Repo.insert!
 end
 #send message to users
 defp send_message(%{body: body, sender: sender,sender_id: sender_id} = payload,socket,room_id) do
   push socket, "room_msg", payload
 end
end
