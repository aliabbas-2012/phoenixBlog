defmodule BlogTest.Plugs.SetUser  do
  import Plug.Conn
  import Phoenix.Controller

  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.AuthorizeToken
  alias BlogTest.ApplicationHelpers

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    auth_token = get_session(conn, :auth_token)

    cond do
      user = user_id && Repo.get(User, user_id)  ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end

    cond do
      auth = auth_token && Repo.get_by(AuthorizeToken, user_id:  user_id, token: auth_token)  ->
        assign(conn, :auth_token, auth.token)
      true ->
        assign(conn, :auth_token, nil)
    end
  end
end
