defmodule PharNote.Repo.Migrations.AddEquipmentPrecisionFields do
  use Ecto.Migration

  #equip-roles have class and a precision
  def change do
    alter table(:equipment_precision) do
      add :precision, :string
      #add :units, :string, null: true
      #add :value, :string, null: true
      #add :lower, :float, null: true
      #add :upper, :float, null: true
     # uniqueness constraint ?
     add :equipment_classes_id,    references(:equipment_classes)
    end
  end
end
