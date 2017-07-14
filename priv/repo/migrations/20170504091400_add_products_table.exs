defmodule PharNote.Repo.Migrations.AddProductsTable do
  use Ecto.Migration

  def change do
    create table(:product) do
      timestamps()
    end
  end
end
