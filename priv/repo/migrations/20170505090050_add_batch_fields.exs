defmodule PharNote.Repo.Migrations.AddBatchFields do
  use Ecto.Migration

  def change do
    alter table(:batch) do
        add :campaign_id,    references(:campaign)

        #? add :order_number,    string
        add :batch_number,    :string


        # other batch parameters?
        add :actual_start, :utc_datetime
        add :actual_end, :utc_datetime
        add :recipe_id,    references(:recipe), null: false #allow null?
        #an iteration state can only be one of the in-production states.
    end
  end
end
