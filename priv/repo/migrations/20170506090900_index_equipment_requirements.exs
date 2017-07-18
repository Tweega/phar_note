defmodule PharNote.Repo.Migrations.IndexEquipmentRequirementsTable do
  use Ecto.Migration

  # a campaign will have a list of equipment requirements

  #we need then to add a history table for this.

  def change do
    create index(:equipment_requirement, [:campaign_id]) #should this just be a constraint?  easier if indexed
  end
end
