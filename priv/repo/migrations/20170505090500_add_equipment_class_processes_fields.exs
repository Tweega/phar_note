defmodule PharNote.Repo.Migrations.AddEquipmentClassProcessesFields do
  use Ecto.Migration

  #this table stores a flattened list of processes, gouped by equipment class, where a class is assumed to share a set of attributes/processes.
  #where do we need this?

  def change do
    alter table(:equipment_class_processes) do
      add :name, :string
      add :description, :string
      add :equipment_class_id,    references(:equipment_classes)
    end
  end
end
