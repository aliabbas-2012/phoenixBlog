defmodule BlogTest.Room do
  use BlogTest.Web, :model

  alias BlogTest.User
  alias BlogTest.Message

  schema "rooms" do
    field :name, :string
    field :room_type, :string
    belongs_to(:user,User)
    has_many(:messages, Message)
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
