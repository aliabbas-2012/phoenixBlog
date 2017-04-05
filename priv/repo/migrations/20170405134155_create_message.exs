defmodule BlogTest.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :user_id, references(:users)
      add :room_id, references(:rooms)

      timestamps()
    end

  end
end
