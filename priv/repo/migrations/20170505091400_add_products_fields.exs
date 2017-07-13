defmodule PharNote.Repo.Migrations.AddProductsFields do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :product_name, :string
      add :product_desc, :string
      add :active_ingredient, :boolean

      #possible strengths?
    end
  end
end
