# web/models/equipment_precision.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentPrecision do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_precision" do
    field :precision,    :string

    has_one :equipment, PharNote.Equipment
    belongs_to :equipment_classes, PharNote.EquipmentClasses

    has_many :equipment_requirement, PharNote.EquipmentRequirement

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment_roles, params \\ :empty) do
    equipment_roles
      |> cast(params, [:precision])
      |> unique_constraint(:name)
  end

  def precision(query) do
      from p in query,
            join: c in PharNote.EquipmentClasses, on: [id: p.equipment_classes_id],
            select: %{ precision: p.precision, class: c.name },
            order_by: [asc: c.name, asc: p.precision]
  end


end
