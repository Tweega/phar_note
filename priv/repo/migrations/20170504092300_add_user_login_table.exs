defmodule PharNote.Repo.Migrations.AddUserSessionTable do
  use Ecto.Migration
  #this records each user log-in time for each session

  def change do
    create table(:user_session) do
      timestamps()
    end
  end
end
