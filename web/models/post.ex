defmodule BlogTest.Post do
  use BlogTest.Web, :model

  alias BlogTest.User

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :content,:string
    belongs_to(:user,User)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title,:content])
    |> validate_required([:title,:content])
  end
end
