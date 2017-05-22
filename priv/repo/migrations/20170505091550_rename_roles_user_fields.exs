defmodule PharNote.Repo.Migrations.RenameUserRolesFields do
  use Ecto.Migration

  def change do
    rename table(:user_roles), :name, to: :role_name
    rename table(:user_roles), :description, to: :role_desc
  end
end
