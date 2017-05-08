defmodule PharNote.Repo.Migrations.AddEquipmentRoleInstancesFields do
  use Ecto.Migration

  #each campaign defines a list of equipment types to be used.
  #this table records the actual equipment items used to fulfil those functions.
  #..with the addition of being able to replace one item with another to fulfil that role.
  # one consideration is that we want to avoid having to max on date to get the current value.
  # so we might in this case also have a history table.
  #if we have a history table we might have the current implementer of role in the role table.
  def change do
    alter table(:equipment_role_instances) do
      add :campaign_id,         references(:campaigns)
      add :equipment_role_id,   references(:equipment_roles)
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
    end
  end
end
