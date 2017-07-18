defmodule PharNote.Repo.Migrations.AddCampaignsTable do
  use Ecto.Migration

  def change do
    create table(:campaign) do
      timestamps()
    end
  end
end
