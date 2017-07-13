defmodule PharNote.Repo.Migrations.AddRolesFields do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :role_name,        :string
      add :role_desc, :string
    end
  end
end
