defmodule BlogTest.UserController do
  use BlogTest.Web, :controller

  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth

  alias BlogTest.User
  alias BlogTest.Address
  alias BlogTest.Email
  alias BlogTest.Mailer

  require IEx



  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{addresses: [
      %Address{address_type: "Home"},
      %Address{address_type: "Office"}
    ]}, %{})


    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)


    case Repo.insert(changeset) do
      {:ok, _user} ->
        Email.welcome_and_confirmation_email(%{changes: changes} = changeset)
        |> BlogTest.Mailer.deliver_now
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id) |> Repo.preload(:addresses)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id) |> Repo.preload(:addresses)
    changeset = User.changeset(user)

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)  |> Repo.preload(:addresses)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
