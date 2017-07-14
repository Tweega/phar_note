defmodule PharNote.Repo.Migrations.AddUserRolesUserTable do
  use Ecto.Migration

  def change do
    create table(:user_role) do
      #timestamps()
    end
  end
end
