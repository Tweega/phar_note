# web/models/equipment.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Campaign do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "campaign" do
    field :campaign_name,    :string
    field :campaign_desc,    :string
    field :order_number,    :string

    field :planned_start, :utc_datetime
    field :planned_end, :utc_datetime
    field :actual_start, :utc_datetime
    field :actual_end, :utc_datetime

    belongs_to :product, PharNote.Product
    belongs_to :location, PharNote.Location

    has_many :equipment_requirement, PharNote.EquipmentRequirement

    #belongs_to :current_state, PharNote.ProcessState

    timestamps()

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment, params \\ :empty) do
    equipment
      |> cast(params, [:campaign_name, :campaign_desc, :order_number])

  end



  def campaign_details(campaigns) do
      #this query leaves some hanging associations not loaded so cannot be used for json api.  For that we need custom map
      from c in campaigns,
          join: l in assoc(c, :location),
          join: p in assoc(c, :product),
          join: req in assoc(c, :equipment_requirement),
          join: ep in assoc(req, :equipment_precision),
          join: ec in assoc(ep, :equipment_classes),
          left_join: cf in assoc(req, :current_fulfilment),
          left_join: eq in assoc(cf, :equipment),
          preload: [:location, :product, equipment_requirement: {req, equipment_precision: {ep, equipment_classes: ec}, current_fulfilment: {cf, equipment: eq}}],


          select: map(c, [:id, :campaign_name, :campaign_desc, :order_number, :planned_start, :planned_end, :actual_start, :actual_end,
          :product_id, :location_id,
          location: [ :id, :location_name ],
          product: [ :id, :product_name ],
          equipment_requirement: [:id, :campaign_id,
                :current_fulfilment_id,
                :equipment_precision_id,
                equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]],
                current_fulfilment: [:id, :equipment_id, equipment: [:id, :name]]]
            ])



        #   :equipment_requirement_id, equipment_requirement: [:id, :equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]]
        #
          #
        #   [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]])
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
