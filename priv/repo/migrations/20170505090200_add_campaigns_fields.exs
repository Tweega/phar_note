defmodule PharNote.Repo.Migrations.AddCampaignsFields do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      add :name, :string
      add :description, :string
      add :planned_start, :utc_datetime
      add :planned_end, :utc_datetime
      add :actual_start, :utc_datetime
      add :actual_end, :utc_datetime

      add :product_id,   references(:products), null: false
      add :location_id,   references(:locations), null: false  #what if campaign may take place in more than one location?  Then build another super-campaign container
      add :parent_location_id,   references(:locations), null: true  #assuming that this is allowed to be null.  Is this the best place for this?

    end
  end
end
