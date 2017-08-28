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

  # %{"name" => "john doe", "addresses" => [
  #   %{"street" => "somewhere", "country" => "brazil", "id" => 1},
  #   %{"street" => "elsewhere", "country" => "poland"},
  # ]}

  def changeset(equipment_class, params \\ :empty) do
    equipment_class
      |> cast(params, [:name, :description])
      |> unique_constraint(:name)
  end

  def changeset_new(equipment_class, params \\ :empty) do
      #requipment_class will just be empty map so could create that here rather than passing in.
    #assuming here that new user will not have any roles, which is probably not going to be the case

#     user
# |> Repo.preload(:addresses)
# |> Ecto.Changeset.cast(params, [])
# |> Ecto.Changeset.cast_assoc(:addresses)

    equipment_class
      |> cast(params, [:name, :description])
      |> unique_constraint(:name)

  end

  def changesetx(equipment_class, params \\ %{}) do
    # struct
    # |> Ecto.Changeset.cast(params, [:title, :body])
    # |> Ecto.Changeset.put_assoc(:tags, parse_tags(params))

    equipment_class
      |> Repo.preload(:equipment_precision)
      |> cast(params, [])
      |> cast_assoc(:equipment_precision)
#      |> unique_constraint(:name)
  end

  defp parse_precisions(params)  do
    (params["precisions"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_tagx/1)
  end

  defp get_or_insert_tagx(precisionID) do
    Repo.get(PharNote.EquipmentPrecision, precisionID)
  end

  defp get_or_insert_precision(name) do
   Repo.get(PharNote.EquipmentPrecision, precisionID) ||
     Repo.insert!(PharNote.EquipmentPrecision, %PharNote.EquipmentPrecision{precision: name})
 end
 #
 # defp insert_and_get_all(names) do
 #    maps = Enum.map(names, &%{name: &1})
 #    Repo.insert_all MyApp.Tag, maps, on_conflict: :nothing
 #    Repo.all(from t in MyApp.Tag, where: t.name in ^names)
 #  end

  defp upsert_all(precisions) do
    #maps = Enum.map(names, &%{name: &1})
    Repo.insert_all PharNote.EquipmentPrecision, precisions, on_conflict: :nothing
    #Repo.all(from t in MyApp.Tag, where: t.precision in ^precisions)
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
