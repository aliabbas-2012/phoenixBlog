defmodule BlogTest.Category do
  use BlogTest.Web, :model

  alias BlogTest.User

  schema "categories" do
    field :name, :string
    belongs_to(:user, User)
    many_to_many :posts, BlogTest.Post, join_through: "categories_posts"
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
