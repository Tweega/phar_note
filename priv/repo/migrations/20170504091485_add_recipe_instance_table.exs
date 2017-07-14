defmodule PharNote.Repo.Migrations.AddRecipeInstanceTable do
  use Ecto.Migration

  def change do
    create table(:recipe_instance) do
      timestamps()
    end
  end
end
