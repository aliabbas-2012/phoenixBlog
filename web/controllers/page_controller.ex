defmodule BlogTest.PageController do
  use BlogTest.Web, :controller

  plug :put_layout, "admin.html"

  def index(conn, _params) do
    recent_posts = BlogTest.Repo.all from p in BlogTest.Post, order_by: [desc: p.updated_at],limit: 2
    render conn, "index.html",recent_posts: recent_posts
  end
end
