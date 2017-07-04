defmodule PharNote.Repo.Migrations.AddEquipmentRoleFields do
  use Ecto.Migration

  #equip-roles have class and a precision
  def change do
    alter table(:equipment_role_precision) do
      add :precision, :string
     # specify belongs to ?
    end
  end
end
