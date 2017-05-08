defmodule PharNote.Repo.Migrations.AddProcessStepsTable do
  use Ecto.Migration
  #it may be that the idea here is to have a way to create lists of check items.
  # a process might be invoked to read throguh all of these, each of which represent a process in their own right.
  # the problem with lists of processes is that the logic boils down to something that is the same for all
  # not sure what we gain with this process other than the fact that no recompilatino is required as a result.
  #a single function runs on all of them - though we do in effect create a separarate process for each.

  def change do
    create table(:process_steps) do
      timestamps()
    end
  end
end
