defmodule BlogTest.RoomController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth

  def show(conn,%{"id"=>id}) do

    render(conn, "show.html", id: id)
  end

end
