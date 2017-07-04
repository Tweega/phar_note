defmodule PharNote.Repo.Migrations.IndexUserRolesTable do
  use Ecto.Migration

  def change do
      create index(:user_roles_user, [:user_id, :role_id])  #why do we need this?
  end
end
