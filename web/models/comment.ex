defmodule BlogTest.Comment do
  use BlogTest.Web, :model

  alias BlogTest.User
  alias BlogTest.Post

  schema "comments" do
    field :content,:string
    belongs_to(:user,User)
    belongs_to(:post,Post)
    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content,:delete])
    |> set_delete_action
    |> validate_required([:content])
  end

  defp set_delete_action(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
