defmodule BlogTest.User do
  use BlogTest.Web, :model

  alias BlogTest.Post

  schema "users" do
    field :user_name, :string
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
    field :gender, :string
    field :provider, :string
    field :token, :string
    has_many(:posts, Post)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
      struct
      |>cast(params,[:user_name,:email,:password,:first_name,:last_name,:gender,:provider,:token])
      |>validate_required([:user_name,:email,:first_name,:last_name])
      |>unique_constraint(:email)
      |>unique_constraint(:user_name)

  end



end
