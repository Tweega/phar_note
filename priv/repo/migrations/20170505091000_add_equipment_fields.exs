defmodule PharNote.Repo.Migrations.AddEquipmentFields do
  use Ecto.Migration

  def change do
    alter table(:equipment) do
      add :name, :string
      add :code, :string
      add :description, :string

      #add :equipment_class_id,    references(:equipment_classes) - through precision
      add :equipment_precision_id,    references(:equipment_precision)

    end
  end
end
