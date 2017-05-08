defmodule PharNote.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      timestamps()
    end
  end
end
