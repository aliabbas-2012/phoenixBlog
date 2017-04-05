defmodule BlogTest.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def up do
    create table(:rooms) do
      add :name, :string
      add :room_type, :string # public or private
      add :user_id, references(:users)
      timestamps()
    end
    create unique_index(:rooms, [:name])
    

  end

  def down do
    drop table(:rooms)
  end
end
