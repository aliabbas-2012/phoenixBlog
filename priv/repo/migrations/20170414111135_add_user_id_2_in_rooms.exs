defmodule BlogTest.Repo.Migrations.AddUserId2InRooms do
  use Ecto.Migration

  def up do
    alter table(:rooms) do
      add :user_id_2, references(:users)
    end
  end

  def down do
    alter table(:images) do
      remove :user_id_2
    end
  end
end
