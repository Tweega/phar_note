# web/models/equipment_class.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentClasses do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_classes" do
    field :name, :string
    field :description, :string

    has_many :equipment_precision, PharNote.EquipmentPrecision

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


  def class_precision(query) do

      from ec in query,
            join: ep in assoc(ec, :equipment_precision),
            preload: [:equipment_precision],
            select: map(ec, [:id, :name, :description, equipment_precision: [:id, :precision]]),
            order_by: [asc: ec.name, asc: ep.precision]
 end


end
