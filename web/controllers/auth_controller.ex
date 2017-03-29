defmodule BlogTest.AuthController do
  use BlogTest.Web, :controller
  plug Ueberauth
  plug :put_layout, "login.html"
  alias BlogTest.Repo
  alias BlogTest.User


  def new(conn,_params) do
    render(conn, "new.html")
  end

  def create(conn,%{"session"=>session_params} = params) do
    IO.inspect("----------")
    IO.inspect(session_params)

    case find_user_by_email(session_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: auth_path(conn, :new))
    end

  end

  #only sketch will be used later
  def callback( conn, params) do

  end

  defp signin(conn, changeset) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> put_session(:user_id, user.id)
    |> redirect(to: page_path(conn, :index))
  end

  defp find_user_by_email(session_params) do
    case Repo.get_by(User, email:  String.downcase(session_params["email"])) do
      nil ->
        {:error, nil}
      user ->
        IO.puts(session_params['password'])
        cond do
          Base.encode16(:erlang.md5(session_params["password"]), case: :lower) == user.password ->
              {:ok, user}
          true ->
              {:error, nil}
        end

    end
  end
end
