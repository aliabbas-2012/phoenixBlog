defmodule BlogTest.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title , :string
      add :slug , :string
      add :content, :text
      add :user_id, references(:users)
      timestamps()
    end

  end
end
