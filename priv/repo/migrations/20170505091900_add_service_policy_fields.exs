defmodule PharNote.Repo.Migrations.AddServicePolicyFields do
  use Ecto.Migration

  #the service policy links services and signature policies.

  #we may dispense with this table and put the policy id in the edge table.

  def change do
    alter table(:policy) do
      add :placeholder, :string
    end
  end
end
