defmodule BlogTest.ProfileController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth
  alias BlogTest.Repo
  alias BlogTest.Image
  alias BlogTest.User
  alias BlogTest.Address
  import Ecto.Query


  require IEx

  def edit(conn, _) do

    user = Repo.get!(User, conn.assigns[:user].id) |> Repo.preload(:addresses) |> Repo.preload(:images)
    changeset = User.changeset(user)
    #POPULATE USER Images IF NOT FOUND
    if  Enum.count(user.images)==0  do
      changeset = Ecto.Changeset.put_assoc(changeset, :images, [%Image{}])
    end

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = Repo.get!(User, conn.assigns[:user].id) |> Repo.preload(:addresses) |> Repo.preload(:images)
    changeset = User.changeset(user, user_params)
    IO.puts "----------"
    IO.inspect changeset

    case Repo.update(changeset) do
      {:ok, user} ->
        put_flash(conn,:info, "User updated successfully.")
        conn  |> redirect(to: profile_path(conn, :show))

      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def show(conn,_) do
    user = Repo.get!(User, conn.assigns[:user].id) |> Repo.preload(:addresses) |> Repo.preload(:images)
    render(conn, "show.html", user: user)

  end
  #change password
  def edit_password(conn,_) do
    user = Repo.get!(User, conn.assigns[:user].id) |>  Repo.preload(:images)
    changeset = User.changeset_for_edit_password(user)


    render(conn, "edit_password.html", user: user, changeset: changeset)
  end

  def update_password(conn,%{"user" => user_params}) do
    user = Repo.get!(User, conn.assigns[:user].id)  |> Repo.preload(:images)
    changeset = User.changeset_for_edit_password(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        put_flash(conn,:info, "password updated successfully.")
        conn  |> redirect(to: profile_path(conn, :show))

      {:error, changeset} ->
        render(conn, "edit_password.html", user: user, changeset: changeset)
    end
  end


end
