# web/models/equipment_requirement.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentRequirement do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_requirement" do
    #field :requirement,    :string  could add a comment field/special notes for the requiremnt, ie preferred actual equipment item

    belongs_to :campaign, PharNote.Campaign
    belongs_to :equipment_precision, PharNote.EquipmentPrecision    #the precision table does not reference requirements
    belongs_to :current_fulfilment, PharNote.RequirementFulfilment

    #from requirement_fulfilment
    has_many :fulfilment, PharNote.RequirementFulfilment

    timestamps()
  end


def requirements() do
    campaign_requirements(PharNote.EquipmentRequirement)
end

def poly_req() do
    requirements_for_campaign("Polyjuice campaign 1")
end

def requirements_for_campaign(campaign_name) do
    x = from req in PharNote.EquipmentRequirement,
    join: c in assoc(req, :campaign),
    where: c.campaign_name == ^campaign_name,
    preload: [:campaign]
    campaign_requirements(x)

    #campaign name is not on 'r' we need to join to campaign table.
    #also this might be a case for not preloading furhter down the line as we haave already preloaded here
    #don't know if this happens automatically or not.
end


  def campaign_requirements(query) do
      #this query leaves some hanging associations not loaded so cannot be used for json api.  For that we need custom map
      from req in query,

          join: ep in assoc(req, :equipment_precision),
          left_join: cf in assoc(req, :current_fulfilment),
          left_join: eq in assoc(cf, :equipment),
          preload: [:equipment_precision, current_fulfilment: {ep, equipment: eq}]

          #preload: [equipment_precision: {ep, equipment: eq}]

          #select: map(eq, [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]])
          #select: %{ equipment_name: eq.name, equipment_code: eq.code, precision: p.precision, class: ec.name }
          #select: %{ equipment_name: eq.name, p: p.precision, c: ec.name}
          #
          # Repo.one from a in App, where: a.id == ^id,
          #         join: f in assoc(a, :form),
          #         join: s in assoc(f, :sections),
          #         join: q in assoc(s, :questions),
          #         preload: [:provider, form: {f, sections: {s, questions: q}}]
  end

end
