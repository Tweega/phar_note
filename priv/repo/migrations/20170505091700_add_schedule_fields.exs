defmodule PharNote.Repo.Migrations.AddScheduleFields do
  use Ecto.Migration

  #events, such as cleaning are scheduled.  when scheduled event expires a chunk of code needs to be executed.
  #this will correspond to an edge into a state.

  def change do
    alter table(:schedule) do
      add :placeholder, :string
    end
  end
end
