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

    #belongs_to :equipment_classes, PharNote.EquipmentClasses - through EquipmentPrecesion
    belongs_to :equipment_precision, PharNote.EquipmentPrecision

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
    from eq in query,
    order_by: [asc: eq.name]
  end

  def with_precision_and_class(query) do
    from eq in query,
    preload: [{:equipment_precision, :equipment_classes}]

    #Repo.all(from u in User, preload: [{:equipment_precision, :equipment_classes}])

  end

def test_map(query) do
    from(eq in query, preload: [{:equipment_precision, :equipment_classes}],
         select: map(eq, [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]]))
#here we need to include the foreign key and target id in the select/map as the join is not explicit.  I presume it looks to the assoc to determin the join fields.
end

def test_preload_join(query) do
    #this query leaves some hanging associations not loaded so cannot be used for json api.  For that we need custom map
    from eq in query,
        join: p in assoc(eq, :equipment_precision),
        join: ec in assoc(p, :equipment_classes),
        preload: [equipment_precision: {p, equipment_classes: ec}]
        #select: map(eq, [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]])
        #select: %{ equipment_name: eq.name, equipment_code: eq.code, precision: p.precision, class: ec.name }
        #select: %{ equipment_name: eq.name, p: p.precision, c: ec.name}
        #
        # Repo.one from a in App, where: a.id == ^id,
        #         join: f in assoc(a, :form),
        #         join: s in assoc(f, :sections),
        #         join: q in assoc(s, :questions),
        #         preload: [:provider, form: {f, sections: {s, questions: q}}]
end


    def test_join(query) do

        from eq in query,
              join: p in PharNote.EquipmentPrecision, on: [id: eq.equipment_precision_id],
              join: c in PharNote.EquipmentClasses, on: [id: p.equipment_classes_id],
             # select: %{ equipment: %{ equip: map(eq, [:name, :code]), precision: map(p, [:id, :precision]), class: map(c, [:name])}}
              select: %{ equipment_name: eq.name, equipment_code: eq.code, precision: p.precision, class: c.name }

              #select: {struct(eq, [:equipment_precision_id, :name]), map(p, [:id, :precision])}

             # select: map([eq, p], [p.precision, eq.name])

              #select: {p.precision, eq.name}

              #where: eq.equipment_precision_id == p.id,

       #        select([t,l], %{
       #    id: t.id,
       #    slug: t.slug,
       #    name: t.name,
       #    user_does_like: fragment("(CASE WHEN l1.id > 0 THEN true ELSE false END) AS user_does_like")
       #  })
       #
       #  query = from s in Song,
       # left_join: v in assoc(:votes),
       # select: %{id: s.id, name: s.name, artist: s.artist, num_votes: count(v.id)}

      #  user = Blog.Repo.one from user in Blog.User,
      # where: user.id == ^user_id,
      # left_join: posts in assoc(user, :posts),
      # left_join: comments in assoc(posts, :comments),
      # preload: [posts: {posts, comments: comments}]
    end



end
