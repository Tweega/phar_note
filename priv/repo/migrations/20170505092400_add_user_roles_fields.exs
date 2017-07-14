defmodule PharNote.Repo.Migrations.AddUserRolesUserFields do
  use Ecto.Migration

  def change do
    alter table(:user_role) do
      add :user_id,    references(:user)
      add :role_id,    references(:role)
    end
  end
end
