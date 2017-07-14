defmodule PharNote.Repo.Migrations.AddProcessStateFields do
  use Ecto.Migration

  #unit procedure states operate at bundle / requirements list level.

  def change do
    alter table(:unit_procedure_state) do
      add :placeholder, :string
      #name, desc, context
    end
  end
end
