defmodule PharNote.Repo.Migrations.AddUserRolesFields do
  use Ecto.Migration

  def change do
    alter table(:user_roles_user) do
      add :user_id,    references(:users)
      add :user_role_id,    references(:user_roles)
    end
  end
end
