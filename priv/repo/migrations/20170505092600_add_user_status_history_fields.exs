defmodule PharNote.Repo.Migrations.AddUserStatusHistoryFields do
  use Ecto.Migration

  def change do
    alter table(:user_status_history) do
      add :user_id,    references(:users)
      add :status_id,   references(:user_status), null: false
    end
  end
end
