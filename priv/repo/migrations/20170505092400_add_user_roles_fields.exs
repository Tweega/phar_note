defmodule PharNote.Repo.Migrations.AddUserRolesUserFields do
  use Ecto.Migration

  def change do
    alter table(:user_roles_user) do
      add :user_id,    references(:users)
      add :role_id,    references(:user_roles)
    end
  end
end
