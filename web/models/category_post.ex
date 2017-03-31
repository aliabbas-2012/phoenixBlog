defmodule BlogTest.CategoryPost do
  use BlogTest.Web, :model

  schema "categories_posts" do
    belongs_to :category, BlogTest.Category
    belongs_to :post, BlogTest.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
  end
end
