defmodule PharNote.Repo.Migrations.AddProductionParameterTable do
  use Ecto.Migration

  def change do
    create table(:production_parameter) do
      timestamps()
    end
  end
end
