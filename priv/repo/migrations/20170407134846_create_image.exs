defmodule BlogTest.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :image, :string
      add :uuid, :string

      timestamps()
    end

  end
end
