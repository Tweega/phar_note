defmodule PharNote.Repo.Migrations.AddUserStatusTable do
  use Ecto.Migration

  #users are active, or inactive. possible awaiting authorisation.
  #in other words users are contexts for processes.
  #do we want to store possible states here or link to normal states table like any other state do da.

  def change do
    create table(:user_status) do
      timestamps()
    end
  end
end
