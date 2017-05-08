defmodule PharNote.Repo.Migrations.AddEquipmentClassStatesTable do
  use Ecto.Migration

  #these are the template state values - not quite sure how state recording will work...whether for example we will have a separate table of processes.
  def change do
    create table(:equipment_class_states) do
    timestamps()
    end
  end
end
