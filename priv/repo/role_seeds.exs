# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PharNote.Repo.insert!(%PharNote.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PharNote.Repo
alias PharNote.Role


Repo.delete_all("user_roles")
Repo.delete_all(Role)



Repo.insert! %Role{ role_name: "Operator", role_desc: "Operators are entrusted with cleaning and other tasks in the pilot plant" }
Repo.insert! %Role{ role_name: "Supervisor", role_desc: "Supervisors can make decisions on cleaning requirements" }
Repo.insert! %Role{ role_name: "Super user", role_desc: "Super user roles have operator privileges but can also add  other users" }
Repo.insert! %Role{ role_name: "Administrator", role_desc: "Administrators can add users  and equipment" }

Repo.insert! %Role{ role_name: "Spell Learner", role_desc: "Can use a wand in class" }
Repo.insert! %Role{ role_name: "Prefect", role_desc: "Can cast expelliarmus anywhere" }
