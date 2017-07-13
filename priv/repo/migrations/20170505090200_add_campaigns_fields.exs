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

      add :product_strength_id,   references(:product_strengths), null: false
      add :location_id,   references(:locations), null: false  #what if campaign may take place in more than one location?  Then build another super-campaign container
      #add :current_state_id, references(:process_state)
    end
  end
end
