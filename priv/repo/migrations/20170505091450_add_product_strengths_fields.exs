defmodule PharNote.Repo.Migrations.AddProductStrengthFields do
  use Ecto.Migration

  def change do
    alter table(:product_strengths) do
      add :strength, :string
      add :product_id, references(:products)
    end
  end
end
