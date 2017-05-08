defmodule PharNote.Repo.Migrations.AddUserStatusFields do
  use Ecto.Migration

  #users are active, or inactive. possible awaiting authorisation.
  #in other words users are contexts for processes.
  #do we want to store possible states here or link to normal states table like any other state do da.

  def change do
    alter table(:user_status_history) do
      add :placeholder, :string
    end
  end
end
