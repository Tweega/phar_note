defmodule PharNote.Repo.Migrations.AddUserRolesUserFields do
  use Ecto.Migration

  def change do
    alter table(:user_roles) do
      add :user_id,    references(:users)
      add :role_id,    references(:roles)
    end
  end
end
