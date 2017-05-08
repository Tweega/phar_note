defmodule PharNote.Repo.Migrations.AddEquipmentTable do
  use Ecto.Migration

  def change do
    create table(:equipment) do
      timestamps()
    end
  end
end
