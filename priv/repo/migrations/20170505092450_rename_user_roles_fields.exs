defmodule PharNote.Repo.Migrations.RenameUserRolesFields do
  use Ecto.Migration

  def change do
    rename table(:user_roles_user), :user_role_id, to: :role_id
  end
end
