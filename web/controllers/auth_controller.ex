defmodule BlogTest.AuthController do
  use BlogTest.Web, :controller
  plug Ueberauth
  plug :put_layout, "login.html"
  alias BlogTest.Repo
  alias BlogTest.User


  def new(conn,_params) do
    render(conn, "new.html")
  end

  #For logout
  def delete(conn,%{"id"=>user_id} = params) do
    IO.puts user_id
    IO.puts user_id === conn.assigns[:user].id
    IO.puts "----"
    cond do
      user_id == conn.assigns[:user].id ->
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

  def create(conn,%{"session"=>session_params} = params) do

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

  #only sketch will be used later
  def callback( conn, params) do

  end

  defp signin(conn, user) do
    conn
    |> put_flash(:info, "Welcome to  #{user.first_name} !")
    |> put_session(:user_id, user.id)
    |> redirect(to: page_path(conn, :index))
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
