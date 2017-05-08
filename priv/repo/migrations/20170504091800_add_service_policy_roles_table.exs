defmodule PharNote.Repo.Migrations.AddServicePolicyRolesTable do
  use Ecto.Migration

  #i think the idea here was to set signature requirements for each user level
  #then a process might link to a policy
  #policies would determine

  #pre-approval (which is actually the addition of a process step),
  #data preparer (which may be to record that an event has been done)
  #data checker (which  may check data / record that other work has been verified)
  #note that data could include photographs / and or voice recording

  #for each category - pre-approver, preparer, checker, (all of these data packets are required by the receiving state)
  # for each category, we specify a number of such signatures required.

  #so we have a signature policy for each edge.
  #so here we have an edge_id and a policy id.

  #this table is where for an edge_id

  #a policy specifies
    # a user role, a number of signatures required, and a category - which might be  pre-approver, preparer, checker

    #so we need a signature category table in which to put pre-approver etc., though as this is so small, perhaps we can hard code in the repo?

  def change do
    create table(:policy_roles) do
        timestamps()
    end
  end
end
