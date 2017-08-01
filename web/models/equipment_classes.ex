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
            select: map(ec, [:id, :name, :description])
  end

  def sorted(query) do
    from ec in query,
    order_by: [asc: ec.name]
  end


   def class_precision(query) do

     #  x = PharNote.EquipmentPrecision |>
     #  PharNote.EquipmentClasses
     #     |> from ec in
     ep_query = from ep in PharNote.EquipmentPrecision, order_by: [asc: ep.precision]

     from ec in query,

         join: ep in assoc(ec, :equipment_precision),
          preload: [equipment_precision: ^ep_query],
          group_by: ec.id,
          select: map(ec, [:id, :name, :description, equipment_precision: [:id, :precision]]),
          order_by: [asc: ec.name]


  end

 def cp_test() do

    #  x = PharNote.EquipmentPrecision |>
    #  PharNote.EquipmentClasses
    #     |> from ec in
    ep_query = from ep in PharNote.EquipmentPrecision, order_by: ep.precision


    x = from ec in PharNote.EquipmentClasses,
        join: ep in assoc(ec, :equipment_precision),
         #preload: [equipment_precision: ^ep_query],
        # group_by: ec.id,
         #select: map(ec, [:id, :name, :description, equipment_precision: [:id, :precision]])
         select: %{ec_id: ec.id, ec_name: ec.name, ec_description: ec.description, precisions: %{ep_id: ep.id, ep_precision: ep.precision}}
         #order_by: [asc: ec.name, asc: ep.precision]
         Repo.all(x)


 end


end
