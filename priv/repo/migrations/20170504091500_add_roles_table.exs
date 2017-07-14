defmodule PharNote.Repo.Migrations.AddRolesTable do
  use Ecto.Migration

  def change do
    create table(:role) do
      timestamps()
    end
  end
end
