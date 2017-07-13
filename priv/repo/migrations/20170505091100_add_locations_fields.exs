defmodule PharNote.Repo.Migrations.AddLocationsFields do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      add :location_name, :string
      add :location_desc, :string
      add :level, :integer

      add :parent_location_id,   references(:locations), null: true  #assuming that this is allowed to be null.  Is this the best place for this?

    end
  end
end
