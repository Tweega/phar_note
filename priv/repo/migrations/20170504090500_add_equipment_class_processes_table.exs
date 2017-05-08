defmodule PharNote.Repo.Migrations.AddEquipmentClassProcessesTable do
  use Ecto.Migration

  #this table stores a flattened list of processes, gouped by equipment class, where a class is assumed to share a set of attributes/processes.
  #where do we need this?

  def change do
    create table(:equipment_class_processes) do
      timestamps()
    end
  end
end
