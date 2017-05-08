defmodule PharNote.Repo.Migrations.AddCampaignsTable do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      timestamps()
    end
  end
end
