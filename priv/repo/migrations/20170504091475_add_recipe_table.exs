defmodule PharNote.Repo.Migrations.AddRecipeTable do
  use Ecto.Migration

  #recipe table is for batches to indicate how to proceed.
  #We will need batch parameters to be stored somewhere, being mindful of not abstracting parameter values into param1, param2 etc.
  #so a recipe will be distinguished also by

  def change do
    create table(:recipe) do
      timestamps()
    end
  end
end
