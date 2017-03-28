defmodule BlogTest.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name,:string
      add :user_id, references(:users)
      timestamps()
    end

    create unique_index(:categories, [:name])

  end
end
