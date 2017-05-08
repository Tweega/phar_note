defmodule PharNote.Repo.Migrations.AddEquipmentStatesTable do
  use Ecto.Migration

  #this is effectively equipment attributes - the setting of each attribute being a process with states
  def change do
    create table(:equipment_states) do
      timestamps()
    end
  end
end
