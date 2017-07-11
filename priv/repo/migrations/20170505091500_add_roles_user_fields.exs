defmodule PharNote.Repo.Migrations.AddUserRolesFields do
  use Ecto.Migration

  def change do
    alter table(:user_roles) do
      add :role_name,        :string
      add :role_desc, :string
    end
  end
end
