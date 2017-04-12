defmodule BlogTest.RoomController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
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

end
