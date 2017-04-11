defmodule BlogTest.RoomController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth

  alias BlogTest.Room
  alias BlogTest.Repo
  alias BlogTest.AuthorizeToken

  def show(conn,%{"id"=>id}) do
    if !Repo.get_by(AuthorizeToken, token:  conn.assigns[:auth_token]) do
      conn
      |> put_flash(:error, "You have invalid token.")
      |> redirect(to: page_path(conn, :index))
    end
    room = Repo.one(from room in Room,
          where: room.id == ^id,
          preload: [{:messages,[{:user,[:images]}]}]
        )
    render(conn, "show.html", room: room)
  end

end
