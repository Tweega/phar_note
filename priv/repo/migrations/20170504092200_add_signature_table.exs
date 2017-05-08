defmodule PharNote.Repo.Migrations.AddSignatureTable do
  use Ecto.Migration

  # when a signaure is required we record edge_id, policy_id:category_id (two ids in total)
  def change do
    create table(:signature) do
      timestamps()
    end
  end
end
