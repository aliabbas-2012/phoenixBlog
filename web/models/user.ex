defmodule BlogTest.User do
  use BlogTest.Web, :model

  alias BlogTest.Post
  alias BlogTest.Address
  alias BlogTest.Message
  alias BlogTest.Comment
  alias BlogTest.Image
  alias BlogTest.AuthorizeToken
  alias BlogTest.ApplicationHelpers
  alias BlogTest.Repo
  alias BlogTest.User

  require IEx

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
    has_many(:images, Image,on_replace: :delete)
    # has_many(:authorize_tokens, AuthorizeToken)


    #related to password update
    field :old_password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do

      struct
      |> cast(params,[:user_name,:email,:password,:first_name,:last_name,:gender])
      |>validate_required([:user_name,:email,:first_name,:last_name])
      |>unique_constraint(:email)
      |>unique_constraint(:user_name)
      |>change_cast_associatios

      #------------------------------------------
      # |> cast_assoc(:messages, required: false)
      # |> cast_assoc(:comments, required: false)
      # |> cast_assoc(:posts, required: false)
      # |> cast_assoc(:authorize_tokens, required: false)


      |> validate_password_on_create
      |> before_save

  end
  #Change set for change password
  def changeset_for_edit_password(struct, params \\ %{}) do
      struct
      |> cast(params,[:user_name,:email,:password,:first_name,:last_name,:gender,:old_password,:new_password,:password_confirmation])
      |> validate_change_password
      |> validate_old_password
      |> validate_ompare_passwords
      |> change_password_before_save
  end

  #cast_assoc user on create and update
  defp change_cast_associatios(changeset) do
    changeset
    |> cast_assoc(:addresses, required: true)
    |> cast_assoc(:images, required: false)
  end

  #special condition if record found
  defp validate_password_on_create(changeset) do
    #only apply when record is new
    if  get_field(changeset, :id)==nil do
      changeset
        |> validate_required([:password])
        |> validate_length(:password, min: 5)
    else
      changeset
    end
  end
  #------- for change password only
  defp validate_change_password(changeset) do

    changeset
      |> validate_required([:old_password,:new_password,:password_confirmation])
      |> validate_length(:new_password, min: 5)
      |> validate_length(:password_confirmation, min: 5)
      |> validate_confirmation(:new_password)
  end
  # validate old password
  defp validate_old_password(changeset) do
    if get_field(changeset, :old_password)!=nil and Repo.get(User,get_field(changeset, :id)).password == ApplicationHelpers.to_md5(get_field(changeset, :old_password)) do
      changeset
    else
      add_error(changeset, :old_password, "is invalid")
    end
  end

  defp validate_ompare_passwords(changeset) do
    if  get_field(changeset, :new_password) == get_field(changeset, :password_confirmation) do
      changeset
    else
      add_error(changeset, :new_password, "does't match with Confirm Password")
    end
  end

  #--------------------------------------------------------------#
  #call always at the end
  defp before_save(changeset) do
    if changeset.valid? && get_field(changeset, :id)==nil do
      changeset
      |> Ecto.Changeset.put_change(:password,ApplicationHelpers.to_md5(get_field(changeset, :password)))
    else
      changeset
    end
  end

  defp change_password_before_save(changeset) do
    if changeset.valid? && get_field(changeset, :id)!=nil do
      changeset
      |> Ecto.Changeset.put_change(:password,ApplicationHelpers.to_md5(get_field(changeset, :new_password)))
    else
      changeset
    end
  end

end
