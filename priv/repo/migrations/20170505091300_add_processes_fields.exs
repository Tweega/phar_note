defmodule PharNote.Repo.Migrations.AddProcessesFields do
  use Ecto.Migration

  # this is a flat view of all processes - which are effectively attributes.
  # what is missing from a bpm perspective is the context - which in this case is assumed to be an equipment item
  # but which in a bpm would be unknown

  def change do
    alter table(:processes) do
      add :placeholder, :string
    end
  end
end
