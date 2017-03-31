defmodule BlogTest.Repo.Migrations.CreateCategoryPost do
  use Ecto.Migration

  def up  do
    create table(:categories_posts) do
      add :post_id , references(:posts)
      add :category_id , references(:categories)
      timestamps()
    end
    alter table(:categories_posts) do
      modify :inserted_at, :datetime, default: fragment("NOW()")
      modify :updated_at, :datetime, default: fragment("NOW()")
    end

  end

  def down do
    drop table(:categories_posts)
  end
end
