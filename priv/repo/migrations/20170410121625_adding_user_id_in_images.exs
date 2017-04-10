defmodule BlogTest.Repo.Migrations.AddingUserIdInImages do
  use Ecto.Migration

  def up do
    alter table(:images) do
      add :user_id, references(:users)

    end
    alter table(:comments) do
      add :post_id, references(:posts)
    end
  end

  def down do
    alter table(:images) do
      remove :user_id
      
    end

    alter table(:comments) do
      remove :post_id
    end
  end
end
