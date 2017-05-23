defmodule PharNote.Repo.Migrations.RemoveUserRolesTimestamps do
  use Ecto.Migration

  def change do
    alter table(:user_roles_user) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
