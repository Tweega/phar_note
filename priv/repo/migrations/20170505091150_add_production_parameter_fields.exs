defmodule PharNote.Repo.Migrations.AddProductionParameterFields do
  use Ecto.Migration

  #these fields will be expected by the production process initial state so should the table name reflect that?
  def change do
    alter table(:production_parameter) do
      add :strength_id,    references(:product_strength)
    end
  end
end
