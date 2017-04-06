defmodule BlogTest.Repo.Migrations.CreateAuthorizeToken do
  use Ecto.Migration

  def change do
    create table(:authorize_tokens) do
      add :token, :string
      add :provider, :string
      add :user_id, references(:users)
      add :expiry_date, :naive_datetime
      timestamps()
    end

  end
end
