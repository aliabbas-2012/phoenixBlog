defmodule BlogTest.Category do
  use BlogTest.Web, :model

  alias BlogTest.User 

  schema "categories" do
    field :name, :string
    belongs_to(:user, User)
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
