defmodule PharNote.Repo.Migrations.AddProductStrengthsTable do
  use Ecto.Migration

  def change do
    create table(:product_strengths) do
      timestamps()
    end
  end
end
