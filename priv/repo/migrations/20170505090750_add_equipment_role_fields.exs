defmodule PharNote.Repo.Migrations.AddEquipmentRoleFields do
  use Ecto.Migration

  #equip-roles have class and a precision
  def change do
    alter table(:equipment_roles) do
      add :name, :string
      add :description, :string
      #has many equipment
      #belongs_to equipment_class
    end
  end
end
