# web/models/product.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Product do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "product" do

    field :product_name, :string
    field :product_desc, :string
    field :active_ingredient, :boolean

    has_many :product_strength, PharNote.ProductStrength

    timestamps()
  end

  def test_join(query) do
      #with this route i am expecting that we won't get nested data as we would with preloading
      from prod in query,
            left_join: ps in PharNote.ProductStrength, on: [product_id: prod.id],
            select: %{ product_name: prod.product_name, product_desc: prod.product_desc, strength: ps.strength }

  end

  def test_preload_join(query) do
      #this query leaves some hanging associations not loaded so cannot be used for json api.  For that we need custom map
      from prod in query,
          join: ps in assoc(prod, :product_strength),
          preload: [:product_strength]
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

  def test_map(query) do
      from(prod in query, preload: [:product_strength],
           select: map(prod, [:product_name, :id, product_strength: [:product_id, :strength]]))


  #          from(eq in query, preload: [{:equipment_precision, :equipment_classes}],
  #               select: map(eq, [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]]))
   end
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:product_name, :product_desc])
      |> unique_constraint(:product_name)
  end

  def changeset_update( product, params \\ :empty) do
       product
        |> Repo.preload(:users)
        |> cast(params, [:product_name, :product_desc])
        |> cast_assoc(:users)
  end

  def changeset_new( product, params \\ :empty) do
    #assuming here that new  product will not have any products, which is probably not going to be the case
     product
        |> cast(params, [:product_name, :product_desc])
        |> unique_constraint(:product_name)
  end


  def sorted(query) do
    from u in query,
    order_by: [asc: u.product_name]
  end

  def with_users(query) do
    from u in query,
    preload: [:users]
  end

  def products(query) do
    from u in query,
      select: map(u, [:id, :product_name, :product_desc])
  end
end
