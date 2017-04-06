defmodule BlogTest.PageController do
  use BlogTest.Web, :controller

  alias BlogTest.Repo
  alias BlogTest.AuthorizeToken

  plug :put_layout, "admin.html"

  def index(conn, _params) do
    recent_posts = BlogTest.Repo.all from p in BlogTest.Post, order_by: [desc: p.updated_at],limit: 2
    render conn, "index.html",recent_posts: recent_posts
  end
  #verify token
  def verify_token(conn,_params) do
    if !Repo.get_by(AuthorizeToken, token:  conn.assigns[:auth_token]) do
      conn
      |> put_flash(:error, "You have invalid token.")
      |> redirect(to: page_path(conn, :index))
    end
    render conn, "verify_token.html"
  end
end
