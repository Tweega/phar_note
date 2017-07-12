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
alias PharNote.EquipmentPrecision
alias PharNote.Equipment

Repo.delete_all(Equipment)

vessel1 = Repo.get_by(EquipmentPrecision, precision: "Personal cauldron")
vessel2 = Repo.get_by(EquipmentPrecision, precision: "Class cauldron")
vessel3 = Repo.get_by(EquipmentPrecision, precision: "YouKnowWho Large")

heater1 = Repo.get_by(EquipmentPrecision, precision: "blast-ended newt")
heater2 = Repo.get_by(EquipmentPrecision, precision: "red dragon")
heater3 = Repo.get_by(EquipmentPrecision, precision: "black dragon")

vent1 = Repo.get_by(EquipmentPrecision, precision: "unicorn tail")
vent2 = Repo.get_by(EquipmentPrecision, precision: "hippogryph tail")
vent3 = Repo.get_by(EquipmentPrecision, precision: "dragon tail")

wand1 = Repo.get_by(EquipmentPrecision, precision: "rat tail core")
wand2 = Repo.get_by(EquipmentPrecision, precision: "unicorn tail core")
wand3 = Repo.get_by(EquipmentPrecision, precision: "phoenix feather core")

cent1 = Repo.get_by(EquipmentPrecision, precision: "slow (100 rpm)")
cent2 = Repo.get_by(EquipmentPrecision, precision: "medium (5000 rpm)")
cent3 = Repo.get_by(EquipmentPrecision, precision: "fast (10000 rpm)")

weigh1 = Repo.get_by(EquipmentPrecision, precision: "0g - 100g")
weigh2 = Repo.get_by(EquipmentPrecision, precision: "100g - 1000g")
weigh3 = Repo.get_by(EquipmentPrecision, precision: "10kg - 100kg")
weigh4 = Repo.get_by(EquipmentPrecision, precision: "1kg - 10kg")
weigh5 = Repo.get_by(EquipmentPrecision, precision: "100kg - 1000kg")
weigh6 = Repo.get_by(EquipmentPrecision, precision: "1ton - 100tons")

pump1 = Repo.get_by(EquipmentPrecision, precision: "sink clearer")
pump2 = Repo.get_by(EquipmentPrecision, precision: "myrtle sluicer")
pump3 = Repo.get_by(EquipmentPrecision, precision: "lake drainer")


Repo.insert! %Equipment{ code: "VESS1", name: "Holdalot Personal cauldron", equipment_precision_id: vessel1.id }
Repo.insert! %Equipment{ code: "VESS2", name: "BroomReady cauldron", equipment_precision_id: vessel1.id }
Repo.insert! %Equipment{ code: "VESS3", name: "Everyday potions cauldron", equipment_precision_id: vessel2.id }
Repo.insert! %Equipment{ code: "VESS4", name: "Half blood potions cauldron", equipment_precision_id: vessel2.id }
Repo.insert! %Equipment{ code: "VESS5", name: "Pure blood potions cauldron", equipment_precision_id: vessel3.id }
Repo.insert! %Equipment{ code: "VESS6", name: "Snape mega cauldron", equipment_precision_id: vessel3.id }

Repo.insert! %Equipment{ code: "HEAT1", name: "toasty singer 1", equipment_precision_id: heater1.id }
Repo.insert! %Equipment{ code: "HEAT2", name: "the charer", equipment_precision_id: heater1.id }
Repo.insert! %Equipment{ code: "HEAT3", name: "dragon breath1", equipment_precision_id: heater2.id }
Repo.insert! %Equipment{ code: "HEAT4", name: "volcano1", equipment_precision_id: heater2.id }
Repo.insert! %Equipment{ code: "HEAT5", name: "volcano belcher", equipment_precision_id: heater3.id }
Repo.insert! %Equipment{ code: "HEAT6", name: "vesuvius", equipment_precision_id: heater3.id }

Repo.insert! %Equipment{ code: "VENT1", name: "windy corner", equipment_precision_id: vent1.id }
Repo.insert! %Equipment{ code: "VENT2", name: "fresh breeze", equipment_precision_id: vent1.id }
Repo.insert! %Equipment{ code: "VENT3", name: "sea gale", equipment_precision_id: vent2.id }
Repo.insert! %Equipment{ code: "VENT4", name: "Neptune's breath", equipment_precision_id: vent2.id }
Repo.insert! %Equipment{ code: "VENT5", name: "Hurricane blow", equipment_precision_id: vent3.id }
Repo.insert! %Equipment{ code: "VENT6", name: "Typhoon sweep", equipment_precision_id: vent3.id }

Repo.insert! %Equipment{ code: "SPIN1", name: "gentle spinner", equipment_precision_id: cent1.id }
Repo.insert! %Equipment{ code: "SPIN2", name: "giddy aunt", equipment_precision_id: cent2.id }
Repo.insert! %Equipment{ code: "SPIN3", name: "tornado spin", equipment_precision_id: cent3.id }

Repo.insert! %Equipment{ code: "WEIGH1", name: "Precise touch pro", equipment_precision_id: weigh1.id }
Repo.insert! %Equipment{ code: "WEIGH2", name: "scaleIT light", equipment_precision_id: weigh2.id }
Repo.insert! %Equipment{ code: "WEIGH3", name: "gravitas1", equipment_precision_id: weigh3.id }
Repo.insert! %Equipment{ code: "WEIGH4", name: "Newton wonder", equipment_precision_id: weigh4.id }
Repo.insert! %Equipment{ code: "WEIGH5", name: "scaleIT heavy", equipment_precision_id: weigh5.id }
Repo.insert! %Equipment{ code: "WEIGH6", name: "mountain meausrer", equipment_precision_id: weigh6.id }


Repo.insert! %Equipment{ code: "PUMP1", name: "Household pump", equipment_precision_id: pump1.id }
Repo.insert! %Equipment{ code: "PUMP2", name: "batchroom pump", equipment_precision_id: pump1.id }
Repo.insert! %Equipment{ code: "PUMP3", name: "Troublesome plumbing", equipment_precision_id: pump2.id }
Repo.insert! %Equipment{ code: "PUMP4", name: "Flood battler", equipment_precision_id: pump3.id }

Repo.insert! %Equipment{ code: "WAND1", name: "squib starter", equipment_precision_id: wand1.id }
Repo.insert! %Equipment{ code: "WAND2", name: "Accio special", equipment_precision_id: wand1.id }
Repo.insert! %Equipment{ code: "WAND3", name: "Ollivander starter", equipment_precision_id: wand1.id }
Repo.insert! %Equipment{ code: "WAND4", name: "Hermione developer", equipment_precision_id: wand2.id }
Repo.insert! %Equipment{ code: "WAND5", name: "Dumblestars", equipment_precision_id: wand3.id }
Repo.insert! %Equipment{ code: "WAND6", name: "Flamel arts", equipment_precision_id: wand3.id }


#for this class, preload precisions,
#crete changeset for those precisons.
#use put_assoc to add new precision
#call repo.update

# ecVessel    |> Repo.preload([:equipment_precision])
#             |> Changeset.change
#             |> Changeset.put_assoc(:equipment_precision, [EquipmentPrecision.changeset(%EquipmentPrecision{}, %{precision: "Big"})])
#             |> Repo.update!
