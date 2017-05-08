defmodule PharNote.Repo.Migrations.AddEquipmentStatesFields do
  use Ecto.Migration

  #this is effectively equipment attributes - the setting of each attribute being a process with states
  def change do
    alter table(:equipment_states) do

      add :state_id,   references(:equipment_class_states), null: false
      add :equipment_id,   references(:equipment), null: false

    end
  end
end
