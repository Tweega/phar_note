defmodule PharNote.Repo.Migrations.AddUnitProcedureStatesTable do
  use Ecto.Migration

  def change do
    create table(:unit_procedure_state) do
      timestamps()
    end
  end
end
