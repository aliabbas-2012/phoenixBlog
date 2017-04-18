defmodule BlogTest.RoomController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug :put_layout, false when action in [:change_user_room]

  plug BlogTest.Plugs.CheckAuth

  alias BlogTest.User
  alias BlogTest.Image
  alias BlogTest.Room
  alias BlogTest.Message
  alias BlogTest.Repo
  alias BlogTest.AuthorizeToken

  use Timex

  def show(conn,%{"id"=>id}) do
    if !Repo.get_by(AuthorizeToken, token:  conn.assigns[:auth_token]) do
      conn
      |> put_flash(:error, "You have invalid token.")
      |> redirect(to: page_path(conn, :index))
    end
    room = Repo.get!(Room,id)
    room = change_private_room_name(room, conn.assigns[:user].id)
    room_messages = Repo.all(
        from m in Message,
        where: m.room_id == ^id,
        where: m.inserted_at >= ^Timex.beginning_of_day(Timex.now), where: m.inserted_at <= ^Timex.end_of_day(Timex.now),
        preload: [{:user,[:images]}]
      )
    users = Repo.all from u in User,
      order_by: [desc: u.first_name],
      join: c in assoc(u, :images),
      preload: [images: c]

    render(conn, "show.html", room: room,room_messages: room_messages,users: users)
  end

  def change_user_room(conn,%{"id"=>id}) do
    room = nil

    case  Repo.one(from room in Room,
        where: (room.user_id == ^conn.assigns[:user].id and room.user_id_2 == ^id) or (room.user_id == ^id and room.user_id_2 == ^conn.assigns[:user].id)
     )
     do
      nil ->
        room_params = %{name: "[#{id}-#{conn.assigns[:user].id}]",room_type: "private",user_id: conn.assigns[:user].id,user_id_2: id}
        room = Room.changeset(%Room{}, room_params) |> Repo.insert!
      room_found ->
        room = room_found
    end
    # requested user that recieve the chat request
    requested_user =  Repo.get(User,id)
    #change the room name
    room = Map.put(room, :name, user_full_name(requested_user))

    room_messages = Repo.all(
        from m in Message,
        where: m.room_id == ^room.id,
        where: m.inserted_at >= ^Timex.beginning_of_day(Timex.now), where: m.inserted_at <= ^Timex.end_of_day(Timex.now),
        preload: [{:user,[:images]}]
      )
    render(conn, "change_user_room.html",room: room,room_messages: room_messages)
  end

end
