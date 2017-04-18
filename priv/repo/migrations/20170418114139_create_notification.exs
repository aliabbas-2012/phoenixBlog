defmodule BlogTest.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :message_id, references(:messages)
      add :is_seen , :boolean, default: false
      timestamps()
    end

  end
end
