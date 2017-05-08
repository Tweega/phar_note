defmodule PharNote.Repo.Migrations.AddScheduleExecutionTable do
  use Ecto.Migration

  #records the times of scheduled event execution.  We may also need somewhere to store event schedules for processes tht fall over
  # though perhaps schedules (other than ad-hoc ones) can be recreated from a plan

  def change do
    create table(:schedule_execution) do
      timestamps()
    end
  end
end
