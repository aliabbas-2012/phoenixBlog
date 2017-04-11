defmodule BlogTest.Plugs.SetUser  do
  import Plug.Conn
  import Phoenix.Controller
  import Ecto.Query

  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.Image
  alias BlogTest.AuthorizeToken
  alias BlogTest.ApplicationHelpers

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    auth_token = get_session(conn, :auth_token)

    cond do
      user =  user_id && Repo.get!(User, user_id) |> Repo.preload(images: from(c in Image, order_by: c.id, limit: 1))  ->
        conn = assign(conn, :user, user)
        #storing auth token
        case Repo.get_by(AuthorizeToken, user_id:  user.id, token: auth_token) do
          auth ->
              assign(conn, :auth_token, auth_token)
          nil ->
              assign(conn, :auth_token, nil)
        end
      true ->
        assign(conn, :user, nil) |> assign(:auth_token, nil)
    end
  end
end
