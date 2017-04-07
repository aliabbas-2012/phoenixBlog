defmodule BlogTest.SetStatic do
  use Plug.Builder

  plug Plug.Static,
    at: "/uploads",
    from: :blog_test,
    only: ~w(images html robots.txt)
  plug :not_found

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
