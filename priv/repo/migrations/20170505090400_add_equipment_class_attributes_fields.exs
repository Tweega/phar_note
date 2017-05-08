defmodule PharNote.Repo.Migrations.AddEquipmentClassStateFields do
  use Ecto.Migration

  #these are the template state values - not quite sure how state recording will work...whether for example we will have a separate table of processes.
  def change do
    alter table(:equipment_class_states) do
      add :placeholder, :string
    end
  end
end
