defmodule PharNote.Repo.Migrations.AddUsersFields do
  use Ecto.Migration

def change do
  alter table(:user) do
    add :first_name,    :string
    add :last_name,     :string
    add :email,         :string
    add :photo_url,     :string
    end
  end
end
