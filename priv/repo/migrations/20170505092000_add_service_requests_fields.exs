defmodule PharNote.Repo.Migrations.AddServiceRequestsFields do
  use Ecto.Migration

  #each time the application makes a request for a service, it is logged here?
  #this would presumable log the incoming json also.

  def change do
    alter table(:service_requests) do
      add :placeholder, :string
    end
  end
end
