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
alias PharNote.Campaign
alias PharNote.EquipmentRequirement
alias PharNote.EquipmentPrecision

Repo.delete_all(EquipmentRequirement)

##polyjuice
polyCampaign = Repo.get_by(Campaign, campaign_name: "Polyjuice campaign 1")

polyVessel = Repo.get_by(EquipmentPrecision, precision: "Class cauldron")
polyWand = Repo.get_by(EquipmentPrecision, precision: "unicorn tail core")
polyCentrifuge = Repo.get_by(EquipmentPrecision, precision: "slow (100 rpm)")
polyWeigher = Repo.get_by(EquipmentPrecision, precision: "0g - 100g")
polyPump = Repo.get_by(EquipmentPrecision, precision: "myrtle sluicer")

Repo.insert! %EquipmentRequirement{ campaign_id: polyCampaign.id, equipment_precision_id: polyVessel.id }
Repo.insert! %EquipmentRequirement{ campaign_id: polyCampaign.id, equipment_precision_id: polyWand.id }
Repo.insert! %EquipmentRequirement{ campaign_id: polyCampaign.id, equipment_precision_id: polyCentrifuge.id }
Repo.insert! %EquipmentRequirement{ campaign_id: polyCampaign.id, equipment_precision_id: polyWeigher.id }
Repo.insert! %EquipmentRequirement{ campaign_id: polyCampaign.id, equipment_precision_id: polyPump.id }



##love potion
loveCampaign = Repo.get_by(Campaign, campaign_name: "LoveAnother campaign 1")
loveVessel = Repo.get_by(EquipmentPrecision, precision: "Personal cauldron")
loveWand = Repo.get_by(EquipmentPrecision, precision: "unicorn tail core")
loveCentrifuge = Repo.get_by(EquipmentPrecision, precision: "medium (5000 rpm)")
loveWeigher = Repo.get_by(EquipmentPrecision, precision: "0g - 100g")
lovePump = Repo.get_by(EquipmentPrecision, precision: "sink clearer")
loveVentilator = Repo.get_by(EquipmentPrecision, precision: "hippogryph tail")
loveHeater = Repo.get_by(EquipmentPrecision, precision: "blast-ended newt")


Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveVessel.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveWand.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveCentrifuge.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveWeigher.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: lovePump.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveVentilator.id }
Repo.insert! %EquipmentRequirement{ campaign_id: loveCampaign.id, equipment_precision_id: loveHeater.id }




#for this class, preload precisions,
#crete changeset for those precisons.
#use put_assoc to add new precision
#call repo.update

# ecVessel    |> Repo.preload([:equipment_precision])
#             |> Changeset.change
#             |> Changeset.put_assoc(:equipment_precision, [EquipmentPrecision.changeset(%EquipmentPrecision{}, %{precision: "Big"})])
#             |> Repo.update!
