defmodule BlogTest.Address do
  use BlogTest.Web, :model

  alias BlogTest.User

  schema "addresses" do
    field :street, :string
    field :address_type, :string
    field :post_code, :string
    field :city, :string
    belongs_to(:user,User)
    field :delete, :boolean, virtual: true


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:street, :address_type,:post_code,:city,:delete])
    |> set_delete_action
    |> validate_required([:street, :address_type])
  end

  defp set_delete_action(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
