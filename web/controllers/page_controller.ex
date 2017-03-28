defmodule BlogTest.PageController do
  use BlogTest.Web, :controller

  plug :put_layout, "admin.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
