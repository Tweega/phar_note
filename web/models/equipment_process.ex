# web/models/equipment_process.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.EquipmentProcess do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo

  #for each process, there may be a set of instructions (or none) for an equipment role

  schema "equipment_process" do
    field :name,        :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(user, paramsaa \\ :empty) do
    user
      |> cast(params, [:name, :description])
      |> unique_constraint(:name)
  end

end
