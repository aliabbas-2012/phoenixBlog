defmodule BlogTest.Room do
  use BlogTest.Web, :model

  schema "rooms" do
    field :name, :string
    field :room_type, :string
    belongs_to(:user,User)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name,:room_type])
    |> validate_required([])
    |> unique_constraint(:name)
  end
end
