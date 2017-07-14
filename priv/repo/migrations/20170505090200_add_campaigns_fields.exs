defmodule PharNote.Repo.Migrations.AddCampaignsFields do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      add :campaign_name, :string
      add :campaign_desc, :string
      add :order_number, :string
      add :planned_start, :utc_datetime
      add :planned_end, :utc_datetime
      add :actual_start, :utc_datetime
      add :actual_end, :utc_datetime

      add :product_id,   references(:product), null: false
      add :location_id,   references(:location), null: false  #what if campaign may take place in more than one location?  Then build another super-campaign container
      #add :current_state_id,    references(:process_states), null: true #allow null?  iterations will have sub states.
    end
  end
end
