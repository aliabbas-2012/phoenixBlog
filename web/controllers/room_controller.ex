defmodule BlogTest.RoomController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth

  alias BlogTest.Room
  alias BlogTest.Repo

  def show(conn,%{"id"=>id}) do
    room = Repo.get!(Room,id)
    render(conn, "show.html", room: room)
  end

end
