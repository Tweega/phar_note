defmodule PharNote.Repo.Migrations.AddUnitProcedureTable do
  use Ecto.Migration

  #this is a process that operates on a bundle - which is a requirements implementation.


  def change do
    create table(:unit_procedure) do
      timestamps()
    end
  end
end
