# web/models/product.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.ProductStrength do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "product_strength" do

    field :strength, :string

    belongs_to :product, PharNote.Product

    timestamps()
  end


    def product_strength(query) do

        from ps in query,

              select: %{ strength: ps.strength, id: ps.id }
    end

    def test_map(query) do
        from(prod_strength in query, preload: [:product],
             select: map(prod_strength, [:strength, :product_id, product: [:id, :product_name]]))


    #          from(eq in query, preload: [{:equipment_precision, :equipment_classes}],
    #               select: map(eq, [:equipment_precision_id, :name, :code, equipment_precision: [:id, :precision, :equipment_classes_id, equipment_classes: [:id, :name]]]))
     end

  def sorted(query) do
    from u in query,
    order_by: [asc: u.strength]
  end

  def with_users(query) do
    from u in query,
    preload: [:users]
  end

  def product_strength(query) do
    from u in query,
      select: map(u, [:id, :strength])
  end
end
