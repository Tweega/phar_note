defmodule PharNote.Repo.Migrations.AddSignatureGroupFields do
  use Ecto.Migration

  # a signature group is a set

  #a signature policy specifies a collection of
    #category, user type, and a number of signatures of that type

  #specifying a signature policy is equivalent to specifying a process?
  #we have to gather each of every kind.

  def change do
    alter table(:signature_group) do
      add :placeholder, :string
    end
  end
end
