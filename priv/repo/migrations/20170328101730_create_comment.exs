defmodule BlogTest.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content,:text
      add :user_id , references(:users)
      timestamps()
    end

  end
end
