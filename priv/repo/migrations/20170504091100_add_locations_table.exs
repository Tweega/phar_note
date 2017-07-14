defmodule PharNote.Repo.Migrations.AddLocationsTable do
  use Ecto.Migration

  def change do
    create table(:location) do
      timestamps()
    end
  end
end
