defmodule PharNote.Repo.Migrations.AddRecipeInstanceFields do
  use Ecto.Migration

  def change do
    alter table(:recipe_instance) do

        #recipe parameters
        #start, end
      add :recipe_id, references(:recipe)
      #add :batch_id, references(:batch) - recipe has_one batch?
      #polymorphic parameters?

      #current_state? - this would be the state at the batch level, the batch having one recipe

      #params, such as product strength - how to reference those if they are to be dynamic?
      #if site 1 records one number and site 2 records another, then how is this managed,
      #or do we have a separate table for each site?  Would we then have different joins depending on site?
      #see articles on appartments.
      #for the moment assume a standard set of parameters.

    end
  end
end
