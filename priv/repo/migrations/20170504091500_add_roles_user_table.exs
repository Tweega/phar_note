defmodule PharNote.Repo.Migrations.AddUserRolesTable do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      timestamps()
    end
  end
end
