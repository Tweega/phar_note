# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eecrit.Repo.insert!(%Eecrit.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PharNote.Role
alias PharNote.User
alias Ecto.Changeset
alias Ecto
alias PharNote.Repo
import Ecto.Query, only: [where: 3]


Repo.delete_all("user_roles_user")


# Relationships
r = Repo.get_by(Role, role_name: "Operator") |> Repo.preload(:users)

filter = User
  |> where([u], u.last_name == "Weasley")


for u <- Repo.all(filter) do
  u
  |> Repo.preload([:user_roles])
  |> Changeset.change
  |> Changeset.put_assoc(:user_roles, [r])
  |> Repo.update!
end
