defmodule PharNote.Repo.Migrations.AddEquipmentRequirementsTable do
  use Ecto.Migration

  # a campaign will have a list of equipment roles - these could be simple place holders with only a text entry
  # and no limitation on what equipment types can be used for the role.
  #so this would simply be a collection of instructions that get mapped up to how those instructions were fulfilled.
  #this could be extended to force a selection from a list of equipment marked as being of this type.
  #being more flexibile allows for a looser description when setting the requirements.
  #could go either way.


  #we need then to add a history table for this.

  def change do
    create table(:equipment_requirement) do
      timestamps()
    end
  end
end
