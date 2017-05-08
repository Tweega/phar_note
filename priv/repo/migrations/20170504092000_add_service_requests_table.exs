defmodule PharNote.Repo.Migrations.AddServiceRequestsTable do
  use Ecto.Migration

  #each time the application makes a request for a service, it is logged here?
  #this would presumable log the incoming json also.

  def change do
    create table(:service_requests) do
      timestamps()
    end
  end
end
