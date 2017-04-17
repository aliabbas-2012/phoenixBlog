defmodule BlogTest.AuthController do
  use BlogTest.Web, :controller

  plug :put_layout, "login.html"
  alias BlogTest.Repo
  alias BlogTest.User
  alias BlogTest.SecureRandom
  alias BlogTest.AuthorizeToken
  alias BlogTest.ApplicationHelpers

  use Timex
  require IEx

  plug Ueberauth


  def new(conn,_params) do
    render(conn, "new.html")
  end

  #For logout
  def delete(conn,%{"id"=>user_id} = _params) do
    cond do
      to_string(user_id) == to_string(conn.assigns[:user].id) ->
        conn
           |> configure_session(drop: true)
           |> put_flash(:info, "successfully signed out!")
           |> redirect(to: auth_path(conn, :new))
      true ->
        conn
           |> put_flash(:error, "Invalid Request!")
           |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn,%{"session"=>session_params} = _params) do

    case find_user_by_email(session_params) do
      {:ok, user} ->
        conn
        |> signin(user)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in,Please double check your email or password")
        |> redirect(to: auth_path(conn, :new))
    end

  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
   conn
   |> put_flash(:error, "Failed to authenticate.")
   |> redirect(to: page_path(conn, :index))
 end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.puts "-------in call back----"
    IO.inspect params
    user_map = split_names(auth.info)
    user_params = %{first_name: user_map.first_name, email: auth.info.email, last_name: user_map.last_name}
    changeset = User.changeset(%User{}, user_params)
    user = insert_or_update_user(changeset)
    IO.inspect user
    IO.puts "----------"
    signin(conn, user,Map.get(params,"provider"))

  end
  #storing auth token
  defp store_token(conn,user,provider) do
    auth_token = Phoenix.Token.sign(conn, "user", user.id)
    token_params = %{user_id: user.id,token: auth_token,provider: provider,expiry_date: Timex.shift(Timex.now, days: 3)}
    AuthorizeToken.changeset(%AuthorizeToken{}, token_params) |> Repo.insert!
    auth_token
  end


  defp signin(conn, user,provider \\ "self") do
    conn
    |> put_flash(:info, "Welcome to  #{user.first_name} !")
    |> put_session(:user_id, user.id)
    |> put_session(:auth_token, store_token(conn,user,provider))
    |> redirect(to: page_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        user
    end
  end


  defp find_user_by_email(session_params) do
    case Repo.get_by(User, email:  String.downcase(session_params["email"])) do
      nil ->
        {:error, nil}
      user ->
        cond do
          BlogTest.ApplicationHelpers.to_md5(session_params["password"]) == user.password ->
              {:ok, user}
          true ->
              {:error, nil}
        end

    end
  end
end
