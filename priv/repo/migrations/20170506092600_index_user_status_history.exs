defmodule PharNote.Repo.Migrations.IndexUserStatusHistoryTable do
  use Ecto.Migration

  def change do
    create index(:user_status_history, [:user_id])  #why do we need this?
  end
end
