defmodule PharNote.Repo.Migrations.AddRecipeFields do
  use Ecto.Migration

  def change do
    alter table(:recipe) do
      add :product_id, references(:product)    #the type of thing that this recipe is for?
      # initial process?

      #add :process_id, references(:process)  # when we are asked to execute this recipe, where do we go?
    end
  end
end
