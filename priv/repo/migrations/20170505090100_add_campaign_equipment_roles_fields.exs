defmodule PharNote.Repo.Migrations.AddCampaignEquipmentRolesFields do
  use Ecto.Migration
  # this table stores for each campaign a list of equipment types needed for the campaign.  the idea is that more than one equipment item,
  # ie scale may be used for the same task during the campaign owing to possible servicing etc.
  def change do
    alter table(:campaign_equipment_roles) do
      add :name,        :string
      add :description, :string

      add :campaign_id,    references(:campaigns)
      add :equipment_class_id,    references(:equipment_classes)
    end
  end
end
