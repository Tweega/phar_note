defmodule PharNote.Repo.Migrations.AddProductsFields do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :name, :string
      add :description, :string

      #possible strengths?
    end
  end
end
