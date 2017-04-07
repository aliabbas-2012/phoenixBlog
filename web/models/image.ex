defmodule BlogTest.Image do
  use BlogTest.Web, :model

  use Arc.Ecto.Schema

  schema "images" do
    field :image, BlogTest.Avatar.Type
    field :uuid, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    params = if params["image"] do
     %{ params | "image" => %Plug.Upload{ params["image"] | filename: UUID.uuid4() <> Path.extname(params["image"].filename) } }
   else
     params
   end
    struct
    |> cast(params, [])
    |> put_change(:uuid, UUID.uuid4())
    |> cast_attachments(params, [:image])
    |> validate_required([:image])
  end
end
