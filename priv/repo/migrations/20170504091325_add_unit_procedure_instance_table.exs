defmodule PharNote.Repo.Migrations.AddUnitProcedureInstanceTable do
  use Ecto.Migration

  #this is a process that operates on a bundle - which is a requirements implementation.


  def change do
    create table(:unit_procedure_instance) do
      timestamps()
    end
  end
end
