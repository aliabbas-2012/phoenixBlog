defmodule BlogTest.Message do
  use BlogTest.Web, :model

  schema "messages" do
    field :content, :string
    belongs_to(:user,User)
    belongs_to(:room,Room)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content,:room_id,:user_id])
    |> validate_required([:content])
  end
end
