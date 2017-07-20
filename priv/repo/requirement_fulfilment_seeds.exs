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
alias PharNote.RequirementFulfilment
alias PharNote.Equipment

Repo.delete_all(RequirementFulfilment)

##polyjuice
vessel = Repo.get_by(Equipment, code: "VESS3")


newFulfilment = Repo.insert! %RequirementFulfilment{ requirement_id: 1, equipment_id: vessel.id }


IO.inspect(newFulfilment.id)

Repo.get(PharNote.EquipmentRequirement, 1)
    |> Repo.preload(:current_fulfilment)
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:current_fulfilment, newFulfilment)
    |> Repo.update

# #changeset = Ecto.Changeset.change(%PharNote.EquipmentRequirement{})
# req
#     |> Repo.preload(:current_fulfilment)
#
#     |> Ecto.Changeset.change(%PharNote.EquipmentRequirement{"current_fulfilment_id" => newFulfilment.id})
#     |> Repo.update()
#
#
# # req
# #   |> Repo.preload(:current_fulfilment)
# #   |> Ecto.Changeset.change
# #   |> Ecto.Changeset.put_assoc(:current_fulfilment, newFulfilment.id)
# #   |> Repo.update()
# #
# #
# #
#
# from(d in Dish, where: d.id == 20, preload: [:vendor, :dietary_prefs]) |> Repo.first |> Dish.changeset(%{})
# |>Ecto.Changeset.put_assoc(:dietary_prefs, dietary_prefs)
#
# dietary_prefs = from(dp in Mp.DietaryPref, where: dp.id in ^[1,2]) |> Repo.all |> Enum.map(&Ecto.Changeset.change/1)
#
#
# def changeset(model, params \\ :invalid) do
#     model
#     |> cast(params, @required_fields ++ @optional_fields)
#     |> cast_assoc(:dietary_prefs)
#     |> cast_assoc(:vendor)
#     |> validate_required(@required_fields)
#   end
#
# #   user      = Repo.get!(User, id)
# #   changeset = User.changeset(user, %{"sector_id" => new_id})
# #   Repo.update!(changeset)
# #
# #
# #   game = Repo.get Game, game_id
# #   player = Repo.get Player, player_id
# #
# #   Repo.preload player, :victory       #necessary?
# #
# #   assoc = Ecto.build_assoc(req, :current_fulfilment, Map.from_struct newFulfilment)
# #   #assoc = Ecto.build_assoc(player, :victory, Map.from_struct game)
# #   changeset = PharNote.EquipmentRequirement.changeset req, Map.from_struct assoc
# #   #changeset = Player.changeset player, Map.from_struct assoc
# #   Repo.update changeset
# #
