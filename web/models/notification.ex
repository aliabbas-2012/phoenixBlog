defmodule BlogTest.Notification do
  use BlogTest.Web, :model

  alias BlogTest.Message

  schema "notifications" do
    belongs_to(:message,Message)
    field :is_seen, :boolean, default: false
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message_id,:is_seen])
    |> validate_required([])
  end
end
