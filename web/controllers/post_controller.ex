defmodule BlogTest.PostController do
  use BlogTest.Web, :controller
  plug :put_layout, "admin.html"
  plug BlogTest.Plugs.CheckAuth
  plug :check_post_owner when action in [:update, :edit, :delete]

  alias BlogTest.Post
  alias BlogTest.Category
  require IEx

  def index(conn, _params) do
    posts = Repo.all from p in Post,
      order_by: [desc: p.updated_at],
      preload: [:user]
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    categories = Repo.all(Category) |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset,categories: categories)
  end

  def create(conn, %{"post" => post_params}) do
    #post categories
    posted_categories = post_params["categories_ids"] && from(p in Category, where: p.id in ^Enum.map(post_params["categories_ids"],fn(x)-> String.to_integer(x) end))  |> Repo.all  || []

    changeset = Post.changeset(%Post{}, post_params)
    |> Ecto.Changeset.put_change(:user_id,conn.assigns[:user].id)
    |> Ecto.Changeset.put_assoc(:categories, posted_categories)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        categories = Repo.all(Category) |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset,categories: categories)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)|> Repo.preload(:user) |> Repo.preload(:categories)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)|> Repo.preload(:categories)
    changeset = Post.changeset(post)
    categories = Repo.all(Category) |> Enum.map(&{&1.name, &1.id})

    render(conn, "edit.html", post: post, changeset: changeset,categories: categories)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do

    #post categories
    posted_categories = post_params["categories_ids"] && from(p in Category, where: p.id in ^Enum.map(post_params["categories_ids"],fn(x)-> String.to_integer(x) end))  |> Repo.all  || []

    post = Repo.get!(Post, id) |>  Repo.preload(:categories)
    changeset = Post.changeset(post, post_params)
    |> Ecto.Changeset.put_change(:user_id,conn.assigns[:user].id)
    |> Ecto.Changeset.put_assoc(:categories, posted_categories)


    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        categories = Repo.all(Category) |> Enum.map(&{&1.name, &1.id})
        render(conn, "edit.html", post: post, changeset: changeset,categories: categories)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  @doc """
   Check the user ownership
   %{assigns: assigns} = conn
   %{params: params} = conn

  """
  defp check_post_owner( %{params: %{"id" => post_id},assigns: %{user: user}} = conn,_params) do
    if Repo.get(Post,post_id).user_id == user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit or delete that post")
      |> redirect(to: post_path(conn, :index))
      |> halt()
    end

  end
end
