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
alias PharNote.EquipmentClasses

Repo.delete_all(EquipmentPrecision)

ecVessel = Repo.get_by(EquipmentClasses, name: "Vessel")
ecHeater = Repo.get_by(EquipmentClasses, name: "Heater")
ecVentilator = Repo.get_by(EquipmentClasses, name: "Ventilator")
#ecThermometer = Repo.get_by(EquipmentClasses, name: "Thermometer")
ecWand = Repo.get_by(EquipmentClasses, name: "Wand")
ecCentrifuge = Repo.get_by(EquipmentClasses, name: "Centrifuge")
ecWeigher = Repo.get_by(EquipmentClasses, name: "Weigher")
ecPump = Repo.get_by(EquipmentClasses, name: "Pump")

Repo.insert! %EquipmentPrecision{ precision: "Personal cauldron", equipment_classes_id: ecVessel.id }
Repo.insert! %EquipmentPrecision{ precision: "Class cauldron", equipment_classes_id: ecVessel.id }
Repo.insert! %EquipmentPrecision{ precision: "YouKnowWho Large", equipment_classes_id: ecVessel.id }

Repo.insert! %EquipmentPrecision{ precision: "blast-ended newt", equipment_classes_id: ecHeater.id }
Repo.insert! %EquipmentPrecision{ precision: "red dragon", equipment_classes_id: ecHeater.id }
Repo.insert! %EquipmentPrecision{ precision: "black dragon", equipment_classes_id: ecHeater.id }

Repo.insert! %EquipmentPrecision{ precision: "unicorn tail", equipment_classes_id: ecVentilator.id }
Repo.insert! %EquipmentPrecision{ precision: "hippogryph tail", equipment_classes_id: ecVentilator.id }
Repo.insert! %EquipmentPrecision{ precision: "dragon tail", equipment_classes_id: ecVentilator.id }

Repo.insert! %EquipmentPrecision{ precision: "rat tail core", equipment_classes_id: ecWand.id }
Repo.insert! %EquipmentPrecision{ precision: "unicorn tail core", equipment_classes_id: ecWand.id }
Repo.insert! %EquipmentPrecision{ precision: "phoenix feather core", equipment_classes_id: ecWand.id }

Repo.insert! %EquipmentPrecision{ precision: "slow (100 rpm)", equipment_classes_id: ecCentrifuge.id }
Repo.insert! %EquipmentPrecision{ precision: "medium (5000 rpm)", equipment_classes_id: ecCentrifuge.id }
Repo.insert! %EquipmentPrecision{ precision: "fast (10000 rpm)", equipment_classes_id: ecCentrifuge.id }

Repo.insert! %EquipmentPrecision{ precision: "0g - 100g", equipment_classes_id: ecWeigher.id }
Repo.insert! %EquipmentPrecision{ precision: "100g - 1000g", equipment_classes_id: ecWeigher.id }
Repo.insert! %EquipmentPrecision{ precision: "1kg - 10kg", equipment_classes_id: ecWeigher.id }
Repo.insert! %EquipmentPrecision{ precision: "10kg - 100kg", equipment_classes_id: ecWeigher.id }
Repo.insert! %EquipmentPrecision{ precision: "100kg - 1000kg", equipment_classes_id: ecWeigher.id }
Repo.insert! %EquipmentPrecision{ precision: "1ton - 100tons", equipment_classes_id: ecWeigher.id }

Repo.insert! %EquipmentPrecision{ precision: "sink clearer", equipment_classes_id: ecPump.id }
Repo.insert! %EquipmentPrecision{ precision: "myrtle sluicer", equipment_classes_id: ecPump.id }
Repo.insert! %EquipmentPrecision{ precision: "lake drainer", equipment_classes_id: ecPump.id }


#for this class, preload precisions,
#crete changeset for those precisons.
#use put_assoc to add new precision
#call repo.update

# ecVessel    |> Repo.preload([:equipment_precision])
#             |> Changeset.change
#             |> Changeset.put_assoc(:equipment_precision, [EquipmentPrecision.changeset(%EquipmentPrecision{}, %{precision: "Big"})])
#             |> Repo.update!
