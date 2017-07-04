# web/models/equipment_role_precision.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentRolePrecision do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_role_precision" do
    field :name,    :string
    field :description,         :string

    belongs_to :equipment_role, PharNote.EquipmentRoles

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment_roles, params \\ :empty) do
    equipment_roles
      |> cast(params, [:name, :description])
      |> unique_constraint(:name)
  end

end
