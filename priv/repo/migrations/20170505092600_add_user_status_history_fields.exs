defmodule PharNote.Repo.Migrations.AddUserStatusHistoryFields do
  use Ecto.Migration

  def change do
    alter table(:user_status_history) do
      add :user_id,    references(:user)
      add :status_id,   references(:user_status), null: false
    end
  end
end
