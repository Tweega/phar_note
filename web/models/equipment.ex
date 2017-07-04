# web/models/equipment.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Equipment do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment" do
    field :name,    :string
    field :code,     :string
    field :description,         :string

    #belongs_to :equipment_classes, PharNote.EquipmentClasses
    has_one :equipment_role, PharNote.EquipmentRoles

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment, params \\ :empty) do
    equipment
      |> cast(params, [:name, :code, :description, :equipment_role])
      |> unique_constraint(:code)
  end


  def sorted(query) do
    from eq in query
  end
end
