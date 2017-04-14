defmodule BlogTest.Room do
  use BlogTest.Web, :model

  alias BlogTest.User
  alias BlogTest.Message

  schema "rooms" do
    field :name, :string
    field :room_type, :string
    belongs_to(:user,User)
    belongs_to(:user2,User,foreign_key: :user_id_2)
    has_many(:messages, Message)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name,:room_type,:user_id,:user_id_2])
    |> validate_required([])
    |> unique_constraint(:name)
  end


  def generate_title_slug(changeset) do
    put_change(changeset, :name, "Test")
  end
end
