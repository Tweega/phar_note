# web/models/equipment_process_instructions.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentProcessInstructions do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "equipment_classes" do
    field :name,        :string
    field :description, :string

    belongs_to :equipment_role, PharNote.EquipmentRoles

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(user, params \\ :empty) do
    user
      |> cast(params, [:name, :description, :equipment_roles])
      |> unique_constraint(:name)
  end

end
