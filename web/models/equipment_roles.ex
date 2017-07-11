# web/models/equipment_roles.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentRoles do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_roles" do
    field :name,    :string
    field :description,         :string
    
    #belongs_to :equipment_roles, PharNote.EquipmentRoles
    #belongs_to :equipment_roles_roles, PharNote.EquipmentRoles

    #belongs_to :equipment_class, PharNote.EquipmentClasses - through precision
    belongs_to :precision, PharNote.EquipmentRolePrecision

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment_roles, params \\ :empty) do
    equipment_roles
      |> cast(params, [:name, :description, :precision, :equipment_class_id])
      |> unique_constraint(:precision, :equipment_class_id)
  end

  def changeset_update(equipment_roles, params \\ :empty) do
      equipment_roles
        |> Repo.preload(:equipment_class)
        |> cast(params, [:name, :description, :equipment_class])
        |> cast_assoc(:equipment_class)
        |> unique_constraint(:name)
  end


  def sorted(query) do
    from r in query,
    order_by: [asc: r.name]
  end

  def with_assoc(query) do
    from eq in query,
    preload: [:equipment_roles_roles],
    preload: [:equipment_roles_roles]
  end

end
