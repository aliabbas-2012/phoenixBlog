defmodule BlogTest.AuthorizeToken do
  use BlogTest.Web, :model

  schema "authorize_tokens" do
    field :token, :string
    field :provider, :string
    field :expiry_date, :naive_datetime
    belongs_to(:user,User)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token,:provider,:expiry_date,:user_id])
    |> validate_required([:token,:expiry_date])
  end
end
