defmodule PharNote.Repo.Migrations.AddLocationsFields do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :name, :string
      add :description, :string

      add :parent_location,   references(:locations), null: true  #assuming that this is allowed to be null.  Is this the best place for this?

    end
  end
end
