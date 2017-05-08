defmodule PharNote.Repo.Migrations.AddEquipmentRequirementsFields do
  use Ecto.Migration

  # a campaign will have a list of equipment roles - these could be simple place holders with only a text entry
  # and no limitation on what equipment types can be used for the role.
  #so this would simply be a collection of instructions that get mapped up to how those instructions were fulfilled.
  #this could be extended to force a selection from a list of equipment marked as being of this type.
  #being more flexibile allows for a looser description when setting the requirements.
  #could go either way.

  #we need then to add a history table for this.

  def change do
    alter table(:equipment_requirements) do
      add :requirement,    :string # this value could perhaps default to the name of the equipment fulfilling the requirement.
      add :precision, :string  #requirement text sufficient for this?

      add :campaign_id,    references(:campaigns)
      add :equipment_id,    references(:equipment)  #this is the equipment that currently fulfils the requirement.
    end
  end
end
