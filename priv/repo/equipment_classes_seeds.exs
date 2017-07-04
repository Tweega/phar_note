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
alias PharNote.EquipmentClasses


Repo.delete_all(EquipmentClasses)


#an equipment class represents a set of instructions. Equipment roles will link to this table.
# there may also be a context in which instructions are used.  So one set of instructions at productions start - another at production end.
#in syncade a class also represents a collection of attributes//processes
Repo.insert! %EquipmentClasses{ name: "Vessel", description: "Container" }
Repo.insert! %EquipmentClasses{ name: "Heater", description: "Heater" }
Repo.insert! %EquipmentClasses{ name: "Ventilator", description: "Ventilator" }
Repo.insert! %EquipmentClasses{ name: "Wand", description: "Wand" }
Repo.insert! %EquipmentClasses{ name: "Thermometer", description: "Thermometer" }
Repo.insert! %EquipmentClasses{ name: "Centrifuge", description: "Centrifuge" }
Repo.insert! %EquipmentClasses{ name: "Pump", description: "Pump" }
Repo.insert! %EquipmentClasses{ name: "Weigher", description: "Weigher" }
