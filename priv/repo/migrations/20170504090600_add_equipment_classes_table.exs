defmodule PharNote.Repo.Migrations.AddEquipmentClassesTable do
  use Ecto.Migration
  # stores list of equipment classes.  Such classes define sets of processes that apply to equipment items.
  # it represents a flat view of processes, which may need re-factoring at some point.
  # each class effectively represents a context type, and these contexts thus have these processes, which seems reasonable.
  # the bpm model may then be extended by recording parents of contexts.

  # here we come to the border of business model and transaction model of the state machine.
  # in that this performs a generic role, and could as easily be called Context table
  # contexts have processes, which have states. We might continue using the specific nomenclature for the moment and abstract later.
  # for abstraction the question is do I need to know that this is an equipment class, or what the specific processes are that are contained here?

  def change do
    create table(:equipment_classes) do
      timestamps()
    end
  end
end
