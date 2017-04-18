defmodule BlogTest.NotificationChannel do
  use BlogTest.Web, :channel
  alias BlogTest.Presence

  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.Notification
  alias BlogTest.Message

  alias BlogTest.Image
  alias BlogTest.ApplicationHelpers
  import Ecto.Query


  def join("notification:room", _message, socket) do
    # room = Repo.get!(Room,roomId)
    send(self, :after_join)

    IO.puts "---HERE---in notificaton room------"
    {:ok, socket}
  end
  def join(_room, _params, _socket) do
    IO.puts "-----in error-------"
    {:error, %{reason: "you can only join the notificaton"}}
  end

  def handle_info(:after_join, socket) do
     IO.puts "------loading notification-------"
     message = %{
            notifications: get_un_read_notification(),
     }
    #  push socket, "notification_history", get_un_read_notification
     broadcast! socket, "notification_history",message
     {:noreply, socket}
  end

  def handle_in("notification_history", payload, socket) do
    message = %{
           notifications: get_un_read_notification(),
    }
    broadcast! socket, "notification_history", message
    {:noreply, socket}
  end

  def terminate(reason, socket) do
     IO.puts socket.assigns.auth.user.first_name
     IO.puts "-------------"
     IO.puts "> leave #{inspect reason}"

     message = %{
            body: "left the notification room ",
            leaving_by: ApplicationHelpers.user_full_name(socket.assigns.auth.user),
            timestamp: :os.system_time(:millisecond)
          }
     broadcast! socket, "leave_notification_room", message
     :ok
  end

  defp get_un_read_notification do
    #===========================#
    # Create another query
    query = from n in Notification,
            join: m in Message, on: m.id == n.message_id,
            join: u in User, on: m.user_id == u.id,
            where: (n.is_seen == false),
            order_by: [desc: n.inserted_at]
    # Extend the query
    query = from [n,m,u] in query,select: %{id: n.id, content: m.content,inserted_at: n.inserted_at,room_id: m.room_id,user_id: u.id,first_name: u.first_name,last_name: u.last_name}
    notifications = Repo.all(query)
    notifications
  end

end
