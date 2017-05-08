defmodule PharNote.Repo.Migrations.AddCampaignEquipmentRolesTable do
  use Ecto.Migration
  # this table stores for each campaign a list of equipment types needed for the campaign.  the idea is that more than one equipment item,
  # ie scale may be used for the same task during the campaign owing to possible servicing etc.
  def change do
    create table(:campaign_equipment_roles) do
      timestamps()
    end
  end
end
