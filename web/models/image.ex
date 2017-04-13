defmodule BlogTest.Image do
  use BlogTest.Web, :model

  alias BlogTest.User
  alias BlogTest.Post

  use Arc.Ecto.Schema

  require IEx

  schema "images" do
    field :image, BlogTest.Avatar.Type
    field :uuid, :string
    belongs_to(:user,User)

    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    IO.puts "her image e--------"
    IO.inspect params

    # IEx.pry

    params = if params["image"] do
     %{ params | "image" => %Plug.Upload{ params["image"] | filename: UUID.uuid4() <> Path.extname(params["image"].filename) } }
   else
     params
   end
    struct
    |> cast(params, [:delete])
    |> set_delete_action
    |> add_uuid_folder
    |> cast_attachments(params, [:image])
    |> validate_required([:image])
  end

  defp add_uuid_folder(changeset) do
    if changeset.valid? && get_field(changeset, :id)==nil do
      changeset
      |> Ecto.Changeset.put_change(:uuid,UUID.uuid4())
    else
      changeset
    end
  end

  defp set_delete_action(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
