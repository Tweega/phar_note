# web/models/equipment_requirement.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentRequirement do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_requirement" do
    #field :requirement,    :string  could add a comment field/special notes for the requiremnt, ie preferred actual equipment item

    belongs_to :campaign, PharNote.Campaign
    belongs_to :equipment_precision, PharNote.EquipmentPrecision
    #belongs_to :current_fulfilment_id, PharNote.EquipmentFulfilment

    timestamps()
  end


end
