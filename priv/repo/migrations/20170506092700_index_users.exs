defmodule PharNote.Repo.Migrations.IndexUsersTable do
  use Ecto.Migration

  def change do
    create index(:user, [:last_name, :first_name])
  end
end
