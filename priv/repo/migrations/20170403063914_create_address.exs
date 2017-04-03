defmodule BlogTest.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :street, :string
      add :address_type, :string
      add :post_code, :string
      add :city, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
