defmodule BlogTest.User do
  use BlogTest.Web, :model

  alias BlogTest.Post
  alias BlogTest.Address
  alias BlogTest.Message
  alias BlogTest.Comment
  alias BlogTest.Image
  alias BlogTest.AuthorizeToken
  alias BlogTest.ApplicationHelpers

  # after_load :calc

  schema "users" do
    field :user_name, :string
    field :email, :string
    field :password, :string
    field :first_name, :string
    field :last_name, :string
    field :gender, :string
    field :provider, :string, virtual: true
    field :token, :string, virtual: true
    field :full_name, :string, virtual: true
    # has_many(:posts, Post)
    has_many(:addresses, Address,on_replace: :nilify)
    # has_many(:messages, Message)
    # has_many(:comments, Comment)
    has_many(:images, Image,on_replace: :nilify)
    # has_many(:authorize_tokens, AuthorizeToken)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
      struct
      |> cast(params,[:user_name,:email,:password,:first_name,:last_name,:gender])
      |> cast_assoc(:addresses, required: true)
      |> cast_assoc(:images, required: false)
      # |> cast_assoc(:messages, required: false)
      # |> cast_assoc(:comments, required: false)
      # |> cast_assoc(:posts, required: false)

      # |> cast_assoc(:authorize_tokens, required: false)
      |>validate_required([:user_name,:email,:first_name,:last_name])
      |>unique_constraint(:email)
      |>unique_constraint(:user_name)
      |>validate_password
      |>before_save

  end
  #special condition if record found
  defp validate_password(changeset) do
    #only apply when record is new
    if  get_field(changeset, :id)==nil do
      changeset
        |> validate_required([:password])
        |> validate_length(:password, min: 5)
    else
      changeset
    end
  end
  #call always at the end
  defp before_save(changeset) do
    if changeset.valid? && get_field(changeset, :id)==nil do
      changeset
      |> Ecto.Changeset.put_change(:password,ApplicationHelpers.to_md5(get_field(changeset, :password)))
    else
      changeset
    end
  end



end
