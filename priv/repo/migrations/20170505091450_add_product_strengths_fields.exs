defmodule PharNote.Repo.Migrations.AddProductStrengthFields do
  use Ecto.Migration

  def change do
    alter table(:product_strength) do
      add :strength, :string
      add :product_id, references(:product)
    end
  end
end
