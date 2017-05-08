defmodule PharNote.Repo.Migrations.AddSignatureFields do
  use Ecto.Migration

  # when a signaure is required we record edge_id, policy_id:category_id (two ids in total)
  def change do
    alter table(:signature) do
      add :placeholder, :string
    end
  end
end
