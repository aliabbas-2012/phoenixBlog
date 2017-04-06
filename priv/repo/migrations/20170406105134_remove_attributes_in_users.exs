defmodule BlogTest.Repo.Migrations.RemoveAttributesInUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove :token
      remove :provider
    end
  end

  def down do
    alter table(:users) do
      add :token, :string
      add :provider, :string
    end
  end
end
