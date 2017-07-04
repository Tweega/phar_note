defmodule PharNote.Repo.Migrations.AddEquipmentProcessStateInstructionTable do
  use Ecto.Migration

  #the idea here is to store the top copy - current value of each process per equipment. - we need a corresponding history table.
  #not sure how the sstate stuff is going to work in detail
  #instruction lists will attach to states.
  def change do
    create table(:equipment_process_state_instruction) do
      timestamps()
    end
  end
end
