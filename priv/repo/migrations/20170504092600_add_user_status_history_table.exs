defmodule PharNote.Repo.Migrations.AddUserStatusHistoryTable do
  use Ecto.Migration

  def change do
    create table(:user_status_history) do
      timestamps()
    end
  end
end
