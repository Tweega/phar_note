# web/models/equipment_class.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.RequirementFulfilment do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "requirement_fulfilment" do

    belongs_to :requirement, PharNote.EquipmentRequirement
    belongs_to :equipment, PharNote.Equipment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment_class, params \\ :empty) do
    equipment_class
      |> cast(params, [:name, :description])
      |> unique_constraint(:name)
  end


  def class(query) do

      from ec in query,
            select: %{ class: ec.name }
  end

  def sorted(query) do
    from ec in query,
    order_by: [asc: ec.name]
  end

end
