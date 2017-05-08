defmodule PharNote.Repo.Migrations.AddUserSessionFields do
  use Ecto.Migration
  #this records each user log-in time for each session

  def change do
    alter table(:user_session) do
      add :placeholder, :string
    end
  end
end
