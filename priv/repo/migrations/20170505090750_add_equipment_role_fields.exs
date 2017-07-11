defmodule PharNote.Repo.Migrations.AddEquipmentRoleFields do
  use Ecto.Migration

  #equip-roles have class and a precision
  def change do
    alter table(:equipment_roles) do
      add :name, :string
      add :description, :string

      #add :equipment_class_id,    references(:equipment_classes)
      add :precision_id,    references(:equipment_precision)
    end
  end
end
