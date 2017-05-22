defmodule PharNote.Repo.Migrations.AddUserRolesFields do
  use Ecto.Migration

  def change do
    alter table(:user_roles) do
      add :name,        :string
      add :description, :string
    end
  end
end
