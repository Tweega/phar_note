defmodule PharNote.Repo.Migrations.AddUnitProcedureFields do
  use Ecto.Migration

  # this is a flat view of all processes - which are effectively attributes.
  # what is missing from a bpm perspective is the context - which in this case is assumed to be an equipment item
  # but which in a bpm would be unknown

  def change do
    alter table(:unit_procedure) do
      add :process_name, :string
      add :process_desc, :string
      #name, desc, context
    end
  end
end
