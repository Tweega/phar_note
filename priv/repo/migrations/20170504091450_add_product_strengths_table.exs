defmodule PharNote.Repo.Migrations.AddProductStrengthsTable do
  use Ecto.Migration

  def change do
    create table(:product_strength) do
      timestamps()
    end
  end
end
