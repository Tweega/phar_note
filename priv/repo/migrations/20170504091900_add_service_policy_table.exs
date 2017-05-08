defmodule PharNote.Repo.Migrations.AddServicePolicyTable do
  use Ecto.Migration

  #the service policy links services and signature policies.

  #we may dispense with this table and put the policy id in the edge table.

  def change do
    create table(:policy) do
      timestamps()
    end
  end
end
