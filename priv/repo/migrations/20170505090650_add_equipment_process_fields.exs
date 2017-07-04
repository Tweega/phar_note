defmodule PharNote.Repo.Migrations.AddEquipmentProcessFields do
  use Ecto.Migration

  #the idea here is to store the top copy - current value of each process per equipment. - we need a corresponding history table.
  #not sure how the state stuff is going to work in detail
  def change do
    alter table(:equipment_process) do
      add :name, :string,
      add :name, :description
      #do we need to know the context type for this? - equipment should be context enough.
      #but processes may start during other processes.  the equipment id is only the root.
      #ignore context for the moment, but we shall likely have to provide this at some point.
    end

  end
end
