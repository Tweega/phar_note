defmodule PharNote.Repo.Migrations.AddScheduleTable do
  use Ecto.Migration

  #events, such as cleaning are scheduled.  when scheduled event expires a chunk of code needs to be executed.
  #this will correspond to an edge into a state.

  def change do
    create table(:schedule) do
      timestamps()
    end
  end
end
