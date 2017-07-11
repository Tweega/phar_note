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

end
