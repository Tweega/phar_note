defmodule PharNote.Repo.Migrations.AddBatchTable do
  use Ecto.Migration
  # batch initially called campaign_iteration
  def change do
    create table(:batch) do
      timestamps()
    end
  end
end
