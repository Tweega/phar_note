defmodule PharNote.Repo.Migrations.AddEquipmentProcessStatesFields do
  use Ecto.Migration

  #the idea here is to store the top copy - current value of each process per equipment. - we need a corresponding history table.
  #not sure how the sstate stuff is going to work in detail
  def change do
    alter table(:equipment_process_state) do
      add :placeholder, :string
    end
  end
end
