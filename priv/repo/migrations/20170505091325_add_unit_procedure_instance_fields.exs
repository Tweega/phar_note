defmodule PharNote.Repo.Migrations.AddUnitProcedureInstanceFields do
  use Ecto.Migration

  #a unit procedure - is a process where the context is a bundle (a collection of wuipment items / requirement implementations.)
  #an instance comes with a specific bundle as context

  def change do
    alter table(:unit_procedure_instance) do
      add :unit_procedure_id, references(:unit_procedure)
      #add :unit_procedure_id, references(:unit_procedure)
    end
  end
end
