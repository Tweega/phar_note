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
import Ecto.Query, only: [where: 3, or_where: 3]


Repo.delete_all("user_roles_user")

# Relationships
r = Repo.get_by(Role, role_name: "Spell Learner") |> Repo.preload(:users)

filter = User
  |> where([u], u.last_name != "Hagrid")
  #|> or_where([u], u.last_name == "Granger")


for u <- Repo.all(filter) do
  u
    |> Repo.preload([:user_roles])
    |> Changeset.change
    |> Changeset.put_assoc(:user_roles, [r])
    |> Repo.update!
end
  r2 = Repo.get_by(Role, role_name: "Prefect") |> Repo.preload(:users)
  #r2 = Repo.all(Role) |> Repo.preload(:users)

filter2 = User
   |> where([u], u.last_name == "Granger")
   |> or_where([u], u.first_name == "Percy")


for u2 <- Repo.all(filter2) do
  u3 = u2
    |> Repo.preload([:user_roles])

  roles = [r2 | u3.user_roles]

  u3
    |> Changeset.change
    |> Changeset.put_assoc(:user_roles, Enum.map(roles, &Changeset.change/1))
    |> Repo.update!
end
